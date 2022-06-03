// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TestContract {

    uint total = 1000;

    function getPart(uint part) public {
        assert(total - part < total);
        total -= part;
    }

    function show() public view returns(uint){
        return total;
    }

}