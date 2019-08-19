const LZkp = artifacts.require("ZkDaiBase.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(LZkp)
};
