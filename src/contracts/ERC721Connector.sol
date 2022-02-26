// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Metadata.sol";
import "./ERC721Enumerable.sol";

// 连接器 
contract ERC721Connector is ERC721Metadata, ERC721Enumerable {
    // 构建函数 传入上链时代币的名称和符号到元合约
    constructor (string memory name, string memory symbol)
    ERC721Metadata(name, symbol)  {}

}