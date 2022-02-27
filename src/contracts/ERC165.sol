// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    // 接口验证，接口存在责返回TRUE
    mapping(bytes4 => bool) private _supportedInterfaces;

    // 构造函数，上链后注册接口supportsInterface
    constructor() {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    // 接口定义函数，外部调用，用于验证接口是否实现
    function supportsInterface(bytes4 interfaceID) external view override returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    // 注册器，使传入的接口Id对应的验证码为TRUE
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, 'Invalid interface request');
        _supportedInterfaces[interfaceId] = true;
    }



}