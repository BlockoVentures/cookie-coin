pragma solidity ^0.4.0;

import "./Token.sol";
import "./ERC20.sol";
import "./ERC223.sol";
import "./ERC223ReceivingContract.sol";
import "./SafeMath.sol";

contract CookieToken is Token("COOKIE", "Cookie coin", 9, 1000), ERC20, ERC223 {

    using SafeMath for uint;

    function CookieToken() public {
        _balanceOf[msg.sender] = _totalSupply;
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr) public constant returns (uint) {
        return _balanceOf[_addr];
    }

    function transfer(address _to, uint _value) public returns (bool) {
        return transfer(_to, _value, "");
    }

    function transfer(address _to, uint _value, bytes _data) public returns (bool) {
        bool isValidValue = (_value > 0);
        bool hasEnoughBalance = (_value <= _balanceOf[msg.sender]);
        bool isAContract = isContract(_to);

        if (!isValidValue || !hasEnoughBalance)
            return false;

        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
        _balanceOf[_to] = _balanceOf[_to].add(_value);

        if (isAContract) {
            ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
            _contract.tokenFallback(msg.sender, _value, _data);
        }

        Transfer(msg.sender, _to, _value, _data);

        return true;
    }

    function isContract(address _addr) private constant returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        bool isValidValue = (_value > 0);
        bool hasPermissionToTransfer = (_allowances[_from][msg.sender] >= _value);
        bool hasEnoughBalance = (_balanceOf[_from] >= _value);

        if (!isValidValue || !hasPermissionToTransfer || !hasEnoughBalance)
            return false;

        _balanceOf[_from] = _balanceOf[_from].sub(_value);
        _balanceOf[_to] = _balanceOf[_to].add(_value);
        _allowances[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint _value) public returns (bool) {
        bool hasEnoughBalance = _balanceOf[msg.sender] >= _value;
        if (!hasEnoughBalance)
            return false;

        _allowances[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);
        
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint) {
        return _allowances[_owner][_spender];
    }
}