// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
    
    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids 
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address, 
         where it is being minted to, the id

    */

contract ERC721 {

    // 代币转移事件
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
        );
    // 授权事件
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
        );

    // 由代币序列地址找到代币持有人的address
    mapping(uint256 => address) private _tokenOwner;
    // 由代币持有人的address查找他持有的代币量
    mapping(address => uint256) private _OwnedTokensCount;

    // 由代币名称映射到代币持有人
    mapping(uint256 => address) private _tokenApprovals;

    // EXERCISE: 1. REGISTER THE INTERFACE FOR THE ERC721 contract so that it includes
    // the following functions: balanceOf, ownerOf, transferFrom
    // *note by register the interface: write the constructors with the 
    // according byte conversions

    // 2.REGISTER THE INTERFACE FOR THE ERC721Enumerable contract so that includes
    // totalSupply, tokenByIndex, tokenOfOwnerByIndex functions

    // 3.REGISTER THE INTERFACE FOR THE ERC721Metadata contract so that includes
    // name and the symbol functions

    // 由代币名字检测是否已经有人发布了此代币
    function _exists(uint256 tokenId) internal view returns(bool){
        //找到代币持有人地址
        address owner = _tokenOwner[tokenId];
        // 如果代币持有人不为空，证明代币已存在，返回true
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual{
        // 需要代币发行到不为空的地址
        require(to != address(0), "ERC721:minting to the zero address");
        // 需要代币不存在
        require(!_exists(tokenId), "ERC721:token already minted");
        
        //we are adding a new address with a token id for minting
        // 新发代币映射到新发代币持有人的地址
        _tokenOwner[tokenId] = to;

        //keeping track of each address that is minting and adding one
        // 新发代币持有人持有的代币总量加一
        _OwnedTokensCount[to] += 1;

        // 代币发行事件
        emit Transfer(address(0), to, tokenId);

    }
    
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    // 查询代币持有人持有代币的数量
    function balanceOf(address _owner) public view returns(uint256) {
        //需要代币持有人地址不为空
        require(_owner != address(0), "owner query for non-existent token");
        // 由代币持有人的地址找到他持有的代币数量
        return _OwnedTokensCount[_owner];

    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    // 由代币ID找到对应的持有人
    function ownerOf(uint256 _tokenId) external view returns (address) {
        // 由代币ID找到对应的持有人地址
        address _owner = _tokenOwner[_tokenId];
        // 需要持有人地址不为空
        require(_owner != address(0), "owner query for non-existent token");
        return _owner;
    }

    // 授权函数
    // 1.需要持有人本身授权
    // 2.授权一个新的持有人地址到一个代币
    // 3.不能授权给自己（当前caller）
    // 4.更新映射到授权的地址
    function approve(address _to, uint256 tokenId) public {
        address owner = this.ownerOf(tokenId);
        //3
        require(_to != owner, "ERROR - approval to current owner");
        //1
        require(msg.sender == owner, "Current caller is not the owner of the token");
        //4
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }


}
