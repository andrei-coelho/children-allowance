// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './SafeMath.sol';

contract Deposit {

    using SafeMath for uint;

    struct Children {
        address wallet;
        uint limit;
        uint next_withdraw_in;
    }

    struct Endorser {
        address wallet;
    }

    struct Account {
        Endorser endorser;
        Children chindren;
        uint amount;
    }

    uint account_index = 0;

    mapping (uint => Account) accounts;

    function createAccount(address _endorser, address _children, uint _limit) internal {
        
        Children memory children = Children(_children, _limit, 0);
        Endorser memory endorser = Endorser(_endorser);
        Account  memory account  = Account(endorser, children, 0);

        account_index++;
        accounts[account_index] = account;

    }

    function depositMoney(uint _account, uint _value) internal {
        accounts[_account].amount = accounts[_account].amount.add(_value);
    }

    function withdrawMoney(uint _account, address _who, uint _value) internal returns(bool) {
        
        Account  storage account  = accounts[_account];
        require(_value <= account.amount);

        Children memory  children = account.chindren;
        
        if( children.wallet == _who 
            && children.limit >= _value 
            && children.next_withdraw_in < block.timestamp){
            account.chindren.next_withdraw_in += 30 days;
            return true;
        }
        
        if(account.endorser.wallet == _who){
            account.amount = account.amount.sub(_value);
            return true;
        }

        return false;

    }

}