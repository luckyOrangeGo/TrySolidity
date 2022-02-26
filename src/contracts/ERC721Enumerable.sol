// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

// 代币队列合约：产生总代币队列和持有人代币队列
contract ERC721Enumerable is ERC721 {

    //全部代币队列
    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    // 在全部代币序列中的tokenId地址映射 
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    // 由代币持有者的地址，找到他在序列中的所有代币ID
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID To index of the owner tokens list
    // 由代币ID找到这个代币在代币持有人的所有代币序列中的地址
    mapping(uint256 => uint256) private _ownedTokensIndex;

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    // 当前代币发行量
    function totalSupply() external view returns (uint256){
        return _allTokens.length;
    }


    // 发行代币时同时执行的函数
    // 这些函数和状态变量只能是内部访问
    // （即从当前合约内部或从它派生的合约访问），
    // 不使用 this 调用。
    function _mint(address to, uint256 tokenId) internal override(ERC721)  {
        super._mint(to, tokenId);
        //2 things! A.add token to the owner
        //B. add tokens to our totalsuppy - to allTokens 
        // 新增代币映射进总代币队列
        _addTokensToTokenEnumeration(tokenId);
        // 新增代币映射进代币持有人的代币序列
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the_alltokens array and set the position of
    // the token index
    // 新增代币映射进总代币队列
    function _addTokensToTokenEnumeration(uint256 tokenId) private {
        // 代币发行时的id映射到全部代币地址中的位置 = 当前代币总量的长度
        _allTokensIndex[tokenId] = _allTokens.length;
        // 将新发代币push进当前全部代币序列
        _allTokens.push(tokenId);
    }

    // 新增代币映射进代币持有人的代币序列
    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        // 1.add address and token id to the ownedTokens
        // 2.ownedTokensIndex tokenId set to address of ownedTokens position
        // 3.we want to execute the function with minting
        // 代币发行时的id映射到代币持有人持有代币地址中的位置 = 持有人持有代币的长度
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        // 将新发代币push进当前持有人代币序列
        _ownedTokens[to].push(tokenId);
    }

    // 检测：通过代币位置查找代币
    function tokenByIndex(uint256 index) public view returns(uint256) {
        // 需要代币位置不超出当前代币总量
        // 外部函数external作为合约接口的一部分，意味着我们可以从其他合约和交易中调用。 
        // 一个外部函数 f 不能从内部调用（即 f 不起作用，但 this.f() 可以）。 
        // 当收到大量数据的时候，外部函数有时候会更有效率，因为数据不会从calldata复制到内存.
        require(index < this.totalSupply(), "global index is out of bound!");
        return _allTokens [index];
    }

    // 检测：通过代币在其持有人队列中的位置查找代币位置
    function tokenOfOwnerByIndex(address owner,uint index) public view returns(uint256) {
        // 需要代币位置不超出持有人代币总量
        require(index < balanceOf(owner), "owner index is out of bound!");
        return _ownedTokens[owner][index];

    }




}