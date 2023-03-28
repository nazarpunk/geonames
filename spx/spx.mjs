import {SypexGeoClient} from "./sypex-geo.client.mjs";

const client = new SypexGeoClient('./../sypex/SxGeoMax.dat');
//const city = client.get('178.162.122.146');
const city = client.get('91.214.85.254');

console.log(city);