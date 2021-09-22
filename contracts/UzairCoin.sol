// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

contract UzairCoin is IERC20 {

    string public constant name = "UzairCoin";
    string public constant symbol = "UZC";
    uint8 public constant decimals = 0;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 1000000000000000000000000;

    using SafeMath for uint256;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address buyer, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][buyer] = numTokens;
        emit Approval(msg.sender, buyer, numTokens);
        return true;
    }

    function allowance(address owner, address buyer) public override view returns (uint) {
        return allowed[owner][buyer];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}


contract DEX {

    IERC20 public token;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() {
        token = new UzairCoin();
    }

    function balanceOf() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function buy () payable public {
        uint256 amountTobuy = msg.value;
        uint256 dexBalance = token.balanceOf(address(this));
        require(dexBalance >= amountTobuy, "Not Enough Tokens available");
        require(amountTobuy > 0, "You need to send some ether");
        token.transfer(msg.sender, amountTobuy);
        emit Bought(amountTobuy);
    }

    function sell (uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
        emit Sold(amount);
    }
}

// contract DEX {

//     IERC20 public token;

//     event Bought(uint256 amount);
//     event Sold(uint256 amount);

//     constructor() {
//         token = new UzairCoin();
//     }

//     function buy () payable public {
//         uint256 amountTobuy = msg.value;
//         uint256 dexBalance = token.balanceOf(address(this));
//         require(dexBalance >= amountTobuy, "Not Enough Tokens available");
//         require(amountTobuy > 0, "You need to send some ether");
//         token.transfer(msg.sender, amountTobuy);
//         emit Bought(amountTobuy);
//     }

//     function sell (uint256 amount) public {
//         require(amount > 0, "You need to sell at least some tokens");
//         uint256 allowance = token.allowance(msg.sender, address(this));
//         require(allowance >= amount, "Check the token allowance");
//         token.transferFrom(msg.sender, address(this), amount);
//         payable(msg.sender).transfer(amount);
//         emit Sold(amount);
//     }

// }

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract DEX {

//     IERC20 public token;

//     event Bought(uint256 amount);
//     event Sold(uint256 amount);

//     constructor(address _token) {
//         token = IERC20(_token);
//     }

//     function buy () payable public {
//         uint256 amountTobuy = msg.value;
//         uint256 dexBalance = token.balanceOf(address(this));
//         require(dexBalance >= amountTobuy, "Not Enough Tokens available");
//         require(amountTobuy > 0, "You need to send some ether");
//         token.transfer(msg.sender, amountTobuy);
//         emit Bought(amountTobuy);
//     }

//     function sell (uint256 amount) public {
//         require(amount > 0, "You need to sell at least some tokens");
//         uint256 allowance = token.allowance(msg.sender, address(this));
//         require(allowance >= amount, "Check the token allowance");
//         token.transferFrom(msg.sender, address(this), amount);
//         payable(msg.sender).transfer(amount);
//         emit Sold(amount);
//     }


// }