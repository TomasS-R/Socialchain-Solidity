const Web3 = require('web3');
const web3 = new Web3();

const id = web3.utils.soliditySha3(1, 1112023);
console.log(id);