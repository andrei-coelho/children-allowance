// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Bank.sol';

contract Allowance is Bank {

    event Created (address _endorser, address _children, uint _account, uint _limit);
    event Transfer(address _endorser, uint _account, uint _to_account, uint _value);
    event Deposit (uint _account, uint _value);

    function create(address _children, uint _limit) payable public {
       
        createAccount(msg.sender, _children, _limit);
        emit Created(msg.sender,  _children, getLastAccount(), _limit);
   
    }

    function deposit(uint _account) payable public {
        depositMoney(_account, msg.value);
    }

    function withdraw(uint _account, uint _value) public {
        
        require(withdrawMoney(_account, msg.sender, _value), "U cant withdraw money");
        
        (bool sent, bytes memory data) = msg.sender.call{value: _value}("");
        require(sent, "Failed to send Ether");
    
    }

    function getLimitMonth(uint _account) view public returns(uint) {
        return accounts[_account].children.limit;
    }

    function accountAmount(uint _account) view public returns(uint) {
        return accounts[_account].amount;
    }

}