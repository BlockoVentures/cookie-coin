var SafeMath = artifacts.require("./SafeMath.sol");
var CookieToken = artifacts.require("./CookieToken.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, CookieToken);
  deployer.deploy(CookieToken).then( () => {
    return deployer.deploy(
      Crowdsale,
      CookieToken.address,
      web3.eth.blockNumber,
      web3.eth.blockNumber+1000,
      web3.toWei(1, 'ether'),
      1
    ).then(()=>{});
  });
};