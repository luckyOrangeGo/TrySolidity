// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Variables {
    // State variables are stored on the blockchain.
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        // Local variables are not saved to the blockchain.
        uint i = 456;

        // 全局变量
        uint timestamp = block.timestamp; // Current block timestamp
        address sender = msg.sender; // address of the caller
    }
}
/*
There are 3 types of variables in Solidity
有三种类型的变量
local 本地
    declared inside a function 在函数内声明
    not stored on the blockchain    不能存贮在区快上
state 状态
    declared outside a function 在函数外声明
    stored on the blockchain    存贮在区块上
global (provides information about the blockchain)  全局，提供关于区块上的信息
*/