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
        Children children;
        uint amount;
        uint limit;
    }

    uint account_index = 0;

    mapping (uint => Account) accounts;

    function getLastAccount() view internal returns(uint) {
        return account_index;
    }

    function createAccount(address _endorser, address _children, uint _limit) internal {
        
        Children memory children = Children(_children, _limit, block.timestamp + 30 days);
        Endorser memory endorser = Endorser(_endorser);
        Account  memory account  = Account(endorser, children, 0, _limit);

        account_index++;
        accounts[account_index] = account;

    }

    function depositMoney(uint _account, uint _value) internal {
        accounts[_account].amount = accounts[_account].amount.add(_value);
    }

    function withdrawMoney(uint _account, address _who, uint _value) internal returns(bool) {
        
        Account  storage account  = accounts[_account];
        require(_value <= account.amount);

        Children storage children = account.children;
        
        if( children.wallet == _who ){
            
            if(children.next_withdraw_in < block.timestamp){
                account.children.next_withdraw_in += 30 days;
                children.limit = children.limit.add(account.limit);
            }

            if(children.limit < _value){
                return false;
            }

            children.limit = children.limit.sub(_value);
            account.amount = account.amount.sub(_value);
            return true;
        }
        
        if(account.endorser.wallet == _who){
            account.amount = account.amount.sub(_value);
            return true;
        }

        return false;

    }

}