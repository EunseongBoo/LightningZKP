const LZkp = artifacts.require("TestZkDai.sol");
const TestDai = artifacts.require("TestDai.sol");
const BN = require('bn.js');
const SCALING_FACTOR = new BN('1000000000000000000');

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(TestDai)
    return deployer.deploy(LZkp,10000,web3.utils.toBN(SCALING_FACTOR),TestDai.address)
};
