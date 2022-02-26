// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721Metadata {
    // 代币名称
    string private _name;
    // 代币符号
    string private _symbol;

    // 构建函数，确定代币名称和符号
    constructor(string memory named, string memory symbolified){
        _name = named;
        _symbol = symbolified;
    }

    // 接收代币名称
    function name() external view returns(string memory) {
        return _name;
    }
    // 接收代币符号
    function symbol() external view returns(string memory) {
        return _symbol;
    }
}


// import './interfaces/IERC721Metadata.sol';
// import './ERC165.sol';

// contract ERC721Metadata is IERC721Metadata, ERC165 {

//     string private _name;
//     string private _symbol;

//     constructor(string memory named, string memory symbolified) {

//         _registerInterface(bytes4(keccak256('name(bytes4)')^
//         keccak256('symbol(bytes4)')));

//         _name = named;
//         _symbol = symbolified;
//     }

//     function name() external view override returns(string memory) {
//         return _name;
//     }

//     function symbol() external view override returns(string memory) {
//     return _symbol;
//     }

// }