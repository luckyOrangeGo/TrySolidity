// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}



/**
 * @dev Implementation of the {IERC20} interface.
 *      {IERC20} 接口的实现。
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 * 此实现与创建令牌的方式无关。这意味着必须使用 {_mint} 在派生合约中添加供应机制。
 * 有关通用机制，请参阅 {ERC20PresetMinterPauser}。
 *
 * TIP: For a detailed writeup see our guide 提示：有关详细的文章，请参阅我们的指南
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 * 我们遵循了一般的 OpenZeppelin 指南：函数在失败时恢复而不是返回 `false`。
 * 这种行为仍然是传统的，并且与 ERC20 应用程序的期望不冲突。
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 * 此外，在调用 {transferFrom} 时会发出 {Approval} 事件。这允许应用程序仅通过
 * 收听所述事件来重建所有帐户的限额。 EIP 的其他实现可能不会发出这些事件，
 * 因为规范没有要求。
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 * 最后，添加了非标准的 {decreaseAllowance} 和 {increaseAllowance} 函数，
 * 以缓解围绕设置限额的众所周知的问题。请参阅 {IERC20-approve}。
 */

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC20 is Context, IERC20 {
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The defaut value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overloaded;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *      以原子方式增加调用者授予 `spender` 的津贴。
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     * 这是 {approve} 的替代方案，可用于缓解 {IERC20-approve} 中描述的问题。
     * Emits an {Approval} event indicating the updated allowance.
     * 发出一个 {Approval} 事件，指示更新的配额。
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     *    `spender` 不能是零地址。
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *      以原子方式减少调用者授予 `spender` 的津贴。
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     * 这是 {approve} 的替代方案，可用于缓解 {IERC20-approve} 中描述的问题。
     * Emits an {Approval} event indicating the updated allowance.
     * 发出一个 {Approval} 事件，指示更新的配额。
     * Requirements:要求
     *
     * - `spender` cannot be the zero address. `spender` 不能是零地址。
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     *      `spender` 必须允许调用者至少有 `subtractedValue`。
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     * 在任何令牌转移之前调用的挂钩。这包括铸造和燃烧。

     * Calling conditions:
     * 调用条件：

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - 当 `from` 和 `to` 都非零时，`from` 的令牌的`amount` 将被转移到 `to`。

     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - 当 `from` 为零时，`amount` 代币将为`to` 铸造。

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - 当 `t​​o` 为 0 时，`amount` 的 `from` 代币将被烧毁。

     * - `from` and `to` are never both zero.
     * - `from` 和 `to` 永远不会都是零。

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     * https://docs.openzeppelin.com/contracts/3.x/extending-contracts#using-hooks
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}


contract MyToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 dollar = 100 cents
        // 1 token = 1 * (10 ** decimals)
        _mint(msg.sender, 100 * 10**uint(decimals()));
    }
}

/*
How to swap tokens

1. Alice has 100 tokens from AliceCoin, which is a ERC20 token.
2. Bob has 100 tokens from BobCoin, which is also a ERC20 token.
3. Alice and Bob wants to trade 10 AliceCoin for 20 BobCoin.
4. Alice or Bob deploys TokenSwap
5. Alice approves TokenSwap to withdraw 10 tokens from AliceCoin
6. Bob approves TokenSwap to withdraw 20 tokens from BobCoin
7. Alice or Bob calls TokenSwap.swap()
8. Alice and Bob traded tokens successfully.
*/

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    uint public amount1;
    IERC20 public token2;
    address public owner2;
    uint public amount2;

    constructor(
        address _token1,
        address _owner1,
        uint _amount1,
        address _token2,
        address _owner2,
        uint _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        amount2 = _amount2;
    }

    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

// // ----------------------------------------------------------------------------
// // Sample token contract
// //
// // Symbol        : {TOKEN SYMBOL}
// // Name          : {TOKEN NAME}
// // Total supply  : {TOTAL SUPPLY}
// // Decimals      : {DECIMAL PLACES}
// // Owner Account : {OWNER ACCOUNT ADDRESS}
// //
// // ----------------------------------------------------------------------------


// library SafeMath {

//     /**
//      * @dev Returns the addition of two unsigned integers, reverting on
//      * overflow.返回两个无符号整数的加法，溢出时 revert
//      *
//      * Counterpart to Solidity's `+` operator.
//      *
//      * Requirements:
//      *
//      * - Addition cannot overflow.
//      */
//     function add(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a + b;
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting on
//      * overflow (when the result is negative).
//      * 返回两个无符号整数的减法，在溢出时 revert （当结果为负时）。
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      *
//      * - Subtraction cannot overflow.
//      */
//     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a - b;
//     }

//     /**
//      * @dev Returns the multiplication of two unsigned integers, reverting on
//      * overflow.返回两个无符号整数的乘积，溢出时 revert 。
//      *
//      * Counterpart to Solidity's `*` operator.
//      *
//      * Requirements:
//      *
//      * - Multiplication cannot overflow.
//      */
//     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a * b;
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers, reverting on
//      * division by zero. The result is rounded towards zero.
//      * 返回两个无符号整数的整数除法，除以零时 revert 。结果向零舍入。
//      * Counterpart to Solidity's `/` operator.
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function div(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a / b;
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * reverting when dividing by zero.
//      * 返回两个无符号整数相除的余数。 （无符号整数模），除以零时 revert 
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a % b;
//     }

//     /**
//      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
//      * 返回两个无符号整数的减法，带有溢出 BOOL 标志。
//      * _Available since v3.4._
//      */
//     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
//         unchecked {
//             if (b > a) return (false, 0);
//             return (true, a - b);
//         }
//     }


// }


// interface IERC20 {
//     /**
//      * @dev 返回现有的Token数量。
//      */
//     function totalSupply() external view returns (uint256);

//     /**
//      * @dev 返回 `account` 拥有的Token数量。
//      */
//     function balanceOf(address account) external view returns (uint256);

//     /**
//      * @dev 将 `amount` 的Token从调用者的帐户转移到 `recipient`。
//      *
//      * 返回一个布尔值，指示操作是否成功。
//      *
//      * 发布一个 {Transfer} 事件.
//      */
//     function transfer(address recipient, uint256 amount) external returns (bool);

//     /**
//      * @dev 通过 {transferFrom} 返回允许 `spender赠与者` 
//      * 代表 `owner所有人` 花费的剩余代币数量（uint256）。默认情况下为零。
//      * 当调用 {approve} 或 {transferFrom} 时，此值会发生变化.
//      */
//     function allowance(address owner, address spender) external view returns (uint256);

//     /**
//      * @dev 将 `amount` 设置为 `spender` 在调用者Caller代币上的限额。
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      * 返回一个布尔值，指示操作是否成功。
//      * IMPORTANT: Beware that changing an allowance with this method brings the risk
//      * that someone may use both the old and the new allowance by unfortunate
//      * transaction ordering. One possible solution to mitigate this race
//      * condition is to first reduce the spender's allowance to 0 and set the
//      * desired value afterwards:
//      * 重要提示：请注意，使用这种方法更改配额会带来风险，
//      * 有人可能会通过不幸的交易排序同时使用旧配额和新配额。
//      * 缓解这种竞争条件的一种可能解决方案是首先将支出者的津贴减少到 0，
//      * 然后设置所需的值：
//      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address spender, uint256 amount) external returns (bool);

//     /**
//      * @dev Moves `amount` tokens from `sender` to `recipient` using the
//      * allowance mechanism. `amount` is then deducted from the caller's
//      * allowance.
//      * 使用津贴机制将“amount金额”的代币从“发送者”转移到“接收者”。
//      * 然后从Caller的津贴中扣除“金额”。
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      * 返回一个布尔值，指示操作是否成功。
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

//     /**
//      * @dev Emitted when `value` tokens are moved from one account (`from`) to
//      * another (`to`).
//      *
//      * Note that `value` may be zero.
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     /**
//      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
//      * a call to {approve}. `value` is the new allowance.
//      */
//     event Approval(address indexed owner, address indexed spender, uint256 value);
// }

// contract Owned {
//   address public owner;
//   address public newOwner;

//   event OwnershipTransferred(address indexed _from, address indexed _to);

//   modifier onlyOwner {
//     require(msg.sender == owner);
//     _;
//   }

//   function transferOwnership(address _newOwner) public onlyOwner {
//     newOwner = _newOwner;
//   }
//   function acceptOwnership() public {
//     require(msg.sender == newOwner);
//     emit OwnershipTransferred(owner, newOwner);
//     owner = newOwner;
//     newOwner = address(0);
//   }
// }


// /**
// Contract function to receive approval and execute function in one call
// Borrowed from MiniMeToken
// 合约功能，一键接收审批和执行功能 , 借自 MiniMeToken
// */
// abstract contract ApproveAndCallFallBack {
//     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public virtual;
// }

// /**
// ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
// */
// contract MFCT is IERC20, Owned {
//     using SafeMath for uint;

//     string public symbol;
//     string public  name;
//     uint8 public decimals;
//     uint public _totalSupply;

//     mapping(address => uint) balances;
//     mapping(address => mapping(address => uint)) allowed;


//     // ------------------------------------------------------------------------
//     // Constructor 创世
//     // ------------------------------------------------------------------------
//     constructor() {
//         symbol = "MFCT";
//         name = "MyFirstCxToken";
//         decimals = 18;
//         owner = msg.sender;
//         _totalSupply = 100;
//         balances[0x21fE1eC95b4ce5d65c67abF3E2ED8a87Ac7799Fb] = _totalSupply;
//         emit Transfer(address(0), 0x21fE1eC95b4ce5d65c67abF3E2ED8a87Ac7799Fb, _totalSupply);
//     }


//     // ------------------------------------------------------------------------
//     // 总供应量
//     // ------------------------------------------------------------------------
//     function totalSupply() public view returns (uint) {
//         return _totalSupply - balances[address(0)];
//     }


//     // ------------------------------------------------------------------------
//     // 获取账户 tokenOwner 的代币余额
//     // ------------------------------------------------------------------------
//     function balanceOf(address tokenOwner) public view returns (uint balance) {
//         return balances[tokenOwner];
//     }


//     // ------------------------------------------------------------------------
//     // 转移持有人（发起人）的代币到新账户（to）
//     // - 持有人（发起人）的帐户必须有足够的余额才能转移
//     // - 0 值转移被允许
//     // ------------------------------------------------------------------------
//     function transfer(address to, uint tokens) public returns (bool success) {
//         balances[msg.sender].sub(tokens);
//         balances[to].add(tokens);
//         emit Transfer(msg.sender, to, tokens);
//         return true;
//     }


//     // ------------------------------------------------------------------------
//     // 代币持有人（发起人）可以批准spender从代币持有人的账户中转出（tokens）数量的代币
//     //
//     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
//     // recommends that there are no checks for the approval double-spend attack
//     // as this should be implemented in user interfaces 
//     // ------------------------------------------------------------------------
//     function approve(address spender, uint tokens) public returns (bool success) {
//         allowed[msg.sender][spender] = tokens;
//         emit Approval(msg.sender, spender, tokens);
//         return true;
//     }


//     // ------------------------------------------------------------------------
//     // Transfer tokens from the from account to the to account
//     // 将代币从 from 账户转移到 to 账户
//     // - From account must have sufficient balance to transfer
//     // - Spender must have sufficient allowance to transfer
//     // - 0 value transfers are allowed
//     // ------------------------------------------------------------------------
//     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
//         balances[from].sub(tokens);
//         allowed[from][msg.sender].sub(tokens);
//         balances[to].add(tokens);
//         emit Transfer(from, to, tokens);
//         return true;
//     }


//     // ------------------------------------------------------------------------
//     // 返回 所有者批准的可以转移到消费者账户的代币数量
//     // ------------------------------------------------------------------------
//     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
//         return allowed[tokenOwner][spender];
//     }


//     // ------------------------------------------------------------------------
//     // 代币所有者可以批准花费者从代币所有者的账户中转移（...）代币。
//     // 然后执行花费者合约函数 receiveApproval(...)
//     // ------------------------------------------------------------------------
//     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
//         allowed[msg.sender][spender] = tokens;
//         emit Approval(msg.sender, spender, tokens);
//         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
//     return true;
//   }


// }