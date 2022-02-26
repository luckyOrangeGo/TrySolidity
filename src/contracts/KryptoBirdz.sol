// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // array to store our nfts
    // 代币名称队列
    string [] public kryptoBirdz;

    // 由代币名称查找代币是否存在
    mapping(string => bool) _kryptoBirdzExists;

    // 发行代币
    function mint(string memory _kryptoBird) public {

        // 需要查找到代币不存在才可发行此新代币
        require(!_kryptoBirdzExists[_kryptoBird],
        'Error - kryptoBird already exists');
        // this is deprecated - uint _id = KryptoBirdz.push(_kryptoBird);
        // 代币新名称push进代币名称队列
        kryptoBirdz.push(_kryptoBird);
        // 代币id=当前代币总量（0位初始位置id）
        uint _id = kryptoBirdz.length - 1;

        // .push no longer returns the length but a ref to the added element
        // 代币发行指令
        _mint(msg.sender, _id);

        // 当前代币名称的存在为true
        _kryptoBirdzExists[_kryptoBird] = true;

    }

    // constructor(string memory _name, string memory _symbol) ERC721Connector(_name, _symbol){
    //     _name='KryptoBird';
    //     _symbol='KBIRDZ';
    // }
    // 构建函数 在合约上链阶段执行，传入当前的代币名称和代号到连接器合约
    constructor() ERC721Connector("KryptoBird", "KBIRDZ"){}

}


/*

// pragma solidity ^0.8.0;

// import "./ERC721Connector.sol";

// // abstract contract KryptoBird is ERC721Connector {
//     // https://learnblockchain.cn/docs/solidity/contracts.html#abstract-contract

// abstract contract KryptoBird is ERC721Connector {


//     // array to store our nfts
//     string[] public kryptoBirdz;

//     mapping(string => bool) _kryptoBirdzExists;
    
//     function mint(string memory _kryptoBird) public {
        
//         require(!_kryptoBirdzExists[_kryptoBird], 
//             "Error kryptoBird already exists");

//         // this is deprecated
//         // uint _id = KryptoBirdz.push(_kryptoBird);
//         // .push no longer returns the length but a ref to the added element
       
//         kryptoBirdz.push(_kryptoBird);
//         uint _id = kryptoBirdz.length - 1;

//         _mint(msg.sender, _id);

//         _kryptoBirdzExists[_kryptoBird] = true;

//     }


//     constructor() ERC721Connector('KryptoBird','KBIRDZ')
//     {}

// }
*/