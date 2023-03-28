import * as fs from 'fs';
import { SypexResponseType } from './response.definition.mjs';
import { unpack } from './unpack.util.mjs';
import { ip2long } from './ip2long.util.mjs';
export class SypexGeoClient {
    constructor(path) {
        if (!fs.existsSync(path)) {
            throw new Error(`Can't open file`);
        }
        const data = fs.openSync(path, 'r');
        const stats = fs.statSync(path);
        this._fileBuffer = Buffer.alloc(stats.size);
        fs.readSync(data, this._fileBuffer, 0, this._fileBuffer.length, 0);
        fs.closeSync(data);
        const headerLength = 40; // in v2.2
        const buff = Buffer.alloc(headerLength);
        this._fileBuffer.copy(buff, 0, 0, buff.length);
        if (buff.toString('utf8', 0, 3) !== "SxG") {
            throw new Error(`Can't open file`);
        }
        const byteIndexLength = buff.readUInt8(10);
        const mainIndexLength = buff.readUInt16BE(11);
        const dbItems = buff.readUInt32BE(15);
        const idLength = buff.readUInt8(19);
        const blockLength = 3 + idLength;
        const regionSize = buff.readUInt32BE(24);
        const packSize = buff.readUInt16BE(38);
        const byteIndexOffset = headerLength + packSize;
        const mainIndexOffset = byteIndexOffset + byteIndexLength * 4;
        const dbBegin = mainIndexOffset + mainIndexLength * 4;
        const regionsBegin = dbBegin + dbItems * blockLength;
        const db = Buffer.alloc(dbBegin - headerLength);
        this._fileBuffer.copy(db, 0, headerLength, dbBegin);
        const formatDescriptions = db.toString('utf8', 0, packSize);
        const descriptions = formatDescriptions.split(String.fromCharCode(0));
        this._state = {
            version: buff.readUInt8(3),
            time: buff.readUInt32BE(4),
            type: buff.readUInt8(8),
            charset: buff.readUInt8(9),
            byteIndexLength, mainIndexLength,
            range: buff.readUInt16BE(13),
            dbItems, idLength, blockLength,
            maxRegion: buff.readUInt16BE(20),
            regionSize, regionsBegin,
            maxCity: buff.readUInt16BE(22),
            citySize: buff.readUInt32BE(28),
            citiesBegin: regionsBegin + regionSize,
            maxCountry: buff.readUInt16BE(32),
            countrySize: buff.readUInt32BE(34),
            packSize, dbBegin,
            countryDescription: descriptions[0],
            regionDescription: descriptions[1],
            cityDescription: descriptions[2],
            byteIndexArray: [],
            mainIndexArray: [],
        };
        let buffPos = packSize;
        for (let i = 0; i < byteIndexLength; i++) {
            this._state.byteIndexArray[i] = db.readUInt32BE(buffPos);
            buffPos += 4;
        }
        for (let i = 0; i < mainIndexLength; i++) {
            this._state.mainIndexArray[i] = db.readUInt32BE(buffPos);
            buffPos += 4;
        }
    }
    getId(blockOffset, offset) {
        const position = this._state.dbBegin + blockOffset + offset * this._state.blockLength - this._state.idLength;
        const buff = Buffer.alloc(3);
        this._fileBuffer.copy(buff, 0, position, position + buff.length);
        return (buff.readUInt8(0) << 16) + (buff.readUInt8(1) << 8) + buff.readUInt8(2);
    }
    getRangeIp(blockOffset, offset) {
        let position = this._state.dbBegin + blockOffset + offset * this._state.blockLength;
        let buff = Buffer.alloc(3);
        this._fileBuffer.copy(buff, 0, position, position + buff.length);
        return (buff.readUInt8(0) << 16) + (buff.readUInt8(1) << 8) + buff.readUInt8(2);
    }
    searchIndex(ipn, min, max) {
        while (max - min > 8) {
            const offset = min + max >> 1;
            ipn > this._state.mainIndexArray[offset] ? (min = offset) : (max = offset);
        }
        while (ipn > this._state.mainIndexArray[min] && min++ < max) {
        }
        return min;
    }
    searchInDB(blockOffset, ipn, min, max) {
        const buff = Buffer.alloc(4);
        buff.writeUInt32BE(ipn, 0);
        buff.writeUInt8(0, 0);
        const ip = buff.readUInt32BE(0);
        if (max - min <= 1) {
            return this.getId(blockOffset, min++);
        }
        while (max - min > 8) {
            const offset = min + max >> 1;
            ip >= this.getRangeIp(blockOffset, offset) ? (min = offset) : (max = offset);
        }
        let less;
        let rangeIp = this.getRangeIp(blockOffset, min);
        if (ipn >= rangeIp) {
            min++;
            less = min < max;
        }
        while (ip >= rangeIp && less) {
            rangeIp = this.getRangeIp(blockOffset, min);
            if (ip >= rangeIp) {
                min++;
                less = min < max;
            }
        }
        return this.getId(blockOffset, min);
    }
    getNum(ip) {
        const ip1n = +ip.split('.')[0];
        if (ip1n === 0 || ip1n === 10 || ip1n === 127 || ip1n >= this._state.byteIndexLength) {
            return null;
        }
        const ipn = ip2long(ip);
        if (ipn === false) {
            return null;
        }
        let min = this._state.byteIndexArray[ip1n - 1];
        let max = this._state.byteIndexArray[ip1n];
        if (max - min > this._state.range) {
            // Ищем блок в основном индексе
            const part = this.searchIndex(ipn, Math.floor(min / this._state.range), Math.floor(max / this._state.range) - 1);
            // Нашли номер блока в котором нужно искать IP, теперь находим нужный блок в БД
            const leftBorder = part > 0 ? part * this._state.range : 0;
            const rightBorder = part > this._state.mainIndexLength ? this._state.dbItems : (part + 1) * this._state.range;
            // Нужно проверить чтобы блок не выходил за пределы блока первого байта
            min = min > leftBorder ? min : leftBorder;
            max = max > rightBorder ? rightBorder : max;
        }
        const length = max - min;
        return this.searchInDB(min * this._state.blockLength, ipn, 0, length);
    }
    readCountry(seek) {
        let position = this._state.citiesBegin + seek;
        let buff = Buffer.alloc(this._state.maxCountry);
        this._fileBuffer.copy(buff, 0, position, position + buff.length);
        return unpack(buff, this._state.countryDescription);
    }
    readRegion(seek) {
        let position = this._state.regionsBegin + seek;
        let buff = Buffer.alloc(this._state.maxRegion);
        this._fileBuffer.copy(buff, 0, position, position + buff.length);
        return unpack(buff, this._state.regionDescription);
    }
    readCity(seek) {
        let position = this._state.citiesBegin + seek;
        let buff = Buffer.alloc(this._state.maxCity);
        this._fileBuffer.copy(buff, 0, position, position + buff.length);
        return unpack(buff, this._state.cityDescription);
    }
    parse(ip, mode) {
        const seek = this.getNum(ip);
        if (seek === null) {
            return null;
        }
        try {
            const city = this.readCity(seek);
            if (mode === SypexResponseType.CITY) {
                return city;
            }
            const region = this.readRegion(city.region_seek);
            if (mode === SypexResponseType.REGION) {
                return region;
            }
            const country = this.readCountry(region.country_seek);
            return mode === SypexResponseType.COUNTRY ? country : {
                city, region, country
            };
        }
        catch (e) {
            return null;
        }
    }
    getCity(ip) {
        return this.parse(ip, SypexResponseType.CITY);
    }
    getRegion(ip) {
        return this.parse(ip, SypexResponseType.REGION);
    }
    getCountry(ip) {
        return this.parse(ip, SypexResponseType.COUNTRY);
    }
    get(ip) {
        return this.parse(ip);
    }
}
