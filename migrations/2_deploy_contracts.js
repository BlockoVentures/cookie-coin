var SafeMath = artifacts.require("./SafeMath.sol");
var CookieToken = artifacts.require("./CookieToken.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, CookieToken);
  deployer.deploy(CookieToken);
};