pragma solidity ^0.4.0;

import "truffle/Assert.sol";
import "../contracts/CookieToken.sol";

contract TestCookieToken {

    uint private _totalSupply = 1000;
    uint private _transferValue = 100;
    
    CookieToken private _cookieToken;
    address private _owner;

    function beforeEach() public {
        _cookieToken = new CookieToken();
    }
    
    function testOwner () public {
        _owner = msg.sender;
        Assert.equal(_owner, msg.sender, "Owner should be contract creator.");
    }

    function testConstructor() public {
        uint allocatedTokens = _cookieToken.balanceOf(this);
        Assert.equal(allocatedTokens, _totalSupply, "Contract creator should hold all supply at beginning.");
    }

    function testTransferWithValidAmount() public {
        _cookieToken.transfer(_owner, _transferValue);

        uint transferredTokens = _cookieToken.balanceOf(_owner);
        uint allocatedTokens = _cookieToken.balanceOf(this);

        Assert.equal(transferredTokens, _transferValue, "Transfered token value should be equals the defined value.");
        Assert.equal(allocatedTokens, _totalSupply - _transferValue, "Owner should have the total amount minus the transfered value.");
    }

    function testTransferWithInvalidAmount() public {
        uint _invalidTransferAmount = _totalSupply + _transferValue;

        bool transferStatus = _cookieToken.transfer(_owner, _invalidTransferAmount);

        Assert.equal(transferStatus, false, "The transfer amount should be less than supply.");
    }

    function testTotalSupply () public {
        uint totalSupply = _cookieToken.totalSupply();

        Assert.equal(totalSupply, _totalSupply, "The tokens in circulation should be equals the supply.");
    }

    function testTransferFromWithInvalidAllocation() public {
        _cookieToken.transfer(_owner, _transferValue);

        bool transferStatus = _cookieToken.transferFrom(_owner, this, _transferValue);

        Assert.equal(transferStatus, false, "Unauthorised addresses should not be able to transfer tokens.");
    }

    function testApproveWithValidAmount() public {
        bool allocationSuccessful = _cookieToken.approve(_owner, _transferValue);

        Assert.equal(allocationSuccessful, true, "Token owner should be able to allocate less than or equal to their holdings");
    }

    function testApproveWithInvalidAmount() public {
        bool allocationSuccessful = _cookieToken.approve(_owner, _totalSupply + _transferValue);

        Assert.equal(allocationSuccessful, false, "Token owner should not be able to allocate more than their holdings");
    }

    function testAllowanceWithNoAllocatedBalance() public {
        uint allowanceAvailable = _cookieToken.allowance(_owner, this);

        Assert.equal(allowanceAvailable, 0, "Spender should not have a balance available");
    }

    function testAllowanceWithAllocatedBalance() public {
        _cookieToken.approve(_owner, 100);

        uint allowanceAvailable = _cookieToken.allowance(_owner, this);

        Assert.equal(allowanceAvailable, 0, "Spender should have a balance of 100 available");
    }    

}