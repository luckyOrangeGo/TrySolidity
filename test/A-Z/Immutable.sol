// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
// 不可变变量就像常量。不可变变量的值可以在构造函数中设置，但之后不能修改。
contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }

    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = 1 wei == 1;

    uint public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = 1 ether == 1e18;
    // 交易是用以太币支付的。类似于 1 美元等于 100 美分，1 以太币等于 10^18 wei
}

contract Gas {
    uint public i = 0;  

    // Using up all of the gas that you send causes your transaction to fail.
    // State changes are undone.
    // Gas spent are not refunded.
    function forever() public {
        // Here we run a loop until all of the gas are spent
        // and the transaction fails
        while (true) {
            i += 1;
        }
        // 不要编写无界循环，因为这可能会达到 gas 限制，从而导致您的交易失败。
    }
    /*您需要多少以适用于交易支付？
    您支付 Gas用量 * Gas价格 为以太，

    Gas是一个计算单位
    花的Gas是交易中使用的Gas总量
    Gas价格是您愿意每个Gas支付多少ether
    较高价格的交易具有更高的优先级，以便包含在块中。

    未用的Gas将退还。

    There are 2 upper bounds to the amount of gas you can spend
    您可以花费的Gas有 2 个上限

    gas limit (max amount of gas you're willing to use for your transaction, set by you)
    Gas限制（您愿意为交易使用的最大Gas量，由您设置）
    block gas limit (max amount of gas allowed in a block, set by the network)
    区块Gas限制（区块中允许的最大Gas量，由网络设置）

    */
}
