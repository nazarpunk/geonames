import * as fs from 'fs';

const buffer = fs.readFileSync('./sypex/SxGeoCity.dat').buffer;

const view = new DataView(buffer);

//const version = view.getInt8(3);

const parser = view.getInt8(8);
const encode = view.getInt8(9);

console.log(parser,encode);


