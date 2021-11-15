pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    // struct allows you to create your own data type

    struct Voter {
        uint256 vote;
        bool voted;
        uint256 weight;
    }

    struct Proposal {
        // bytes are basic unit of measurement of information in computer processing
        //  use one of bytes1 to bytes32 because they are much cheaper than string
        bytes32 name; // name of each proposal
        uint256 voteCount; // number of accumulated votes
    }

    Proposal[] public proposals;

    mapping(address => Voter) public voters;

    address public chairperson;

    // memory defines a temporary data location in solidity during runtime only of methods
    // var is destroyed after runtime
    // memory is just for temporary data
    // liking to js, if we dont want to change a mutable var value
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;

        voters[chairperson].weight = 1;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    modifier isChairman() {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        _;
    }

    // authenticate voter
    function giveRightToVote(address voter) public isChairman {
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    //  proposal is index of proposal in the proposals array
    function vote(uint256 proposal) public {
        // storage is used because we want to mutate

        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");

        sender.voted = true;
        sender.vote = proposal;

        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
