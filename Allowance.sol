// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Deposit.sol';

contract Allowance is Deposit {

    event Created(uint account);

    function create(address _children, uint _limit) payable public {
       
        createAccount(msg.sender, _children, _limit);
        emit Created(getLastAccount());
   
    }

    function deposit(uint _account) payable public {
        depositMoney(_account, msg.value);
    }

    function withdraw(uint _account, uint _value) public {
        
        require(withdrawMoney(_account, msg.sender, _value), "U cant withdraw money");
        
        (bool sent, bytes memory data) = msg.sender.call{value: _value}("");
        require(sent, "Failed to send Ether");
    
    }

}