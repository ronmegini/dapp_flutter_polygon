var fs = require('fs')
const IMAGES_CID = 'Qmcg6j1kvHVa7HpsmmQLPXy3RVPbP93tbMMYovr1Bn9Pox';
console.log('Images CID', IMAGES_CID);
// Error message if no args
if (process.argv.length != 4) return console.log('Enter first and last circle number');
const myArgs = process.argv.slice(2);
var first = parseInt(myArgs[0]);
var last = parseInt(myArgs[1]);
for (var i = first; i <= last; i++) {
  var fileName = 'JSON/Circle ' + i.toString() + '.json';
  console.log('Updating file', fileName);
  const data = fs.readFileSync(fileName, { encoding: 'utf8', flag: 'r' });
  // console.log('before', data);
  var result = data.replace("IMAGES_CID", IMAGES_CID);
  // console.log('after', result);
  fs.writeFileSync(fileName, result);
}
