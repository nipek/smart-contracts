pragma solidity >=0.7.0 <0.9.0;

// public key word makes it accessible to other contraces

contract Coin {
    address public minter;
    mapping(address => uint256) public balances;

    // events allows the client to react to specific contract changes you declare

    event Sent(address from, address to, uint256 amount);

    constructor() {
        // only runs when deployed
        minter = msg.sender;
    }

    // make new coins and send them to an address
    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint256 requested, uint256 available);

    // send any amount of coins to an existing address
    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
