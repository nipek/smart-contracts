// >= 0.5.x
pragma solidity ^0.5.7;

contract Will {
    address owner;
    uint256 fortune;
    bool deceased;

    // it is payable and public
    //contructors are ran when the contract is first deployed
    constructor() public payable {
        owner = msg.sender;
        fortune = msg.value;
        deceased = false;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _; // continue to the next function
    }

    modifier mustBeDeceased() {
        require(deceased == true);
        _;
    }

    // list of family wallets
    // payable means can send and receive ether
    address payable[] familyWallets;

    // key value storage
    // address is key
    // uint is value typeof
    mapping(address => uint256) inheritance;

    // set inheritance for each address
    // payable means address can send and receive ether
    function setInheritance(address payable wallet, uint256 amount)
        public
        onlyOwner
    {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    // pay each family member based on their wallet address

    function payout() private mustBeDeceased {
        for (uint256 i = 0; i < familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
            // transfering from contract address to family wallet address
        }
    }

    // oracle switch simulation
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}
