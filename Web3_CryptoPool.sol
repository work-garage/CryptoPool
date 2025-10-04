// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Pool is VRFConsumerBaseV2Plus {

    address public admin;
    address[] public players;
    uint256 public ticketPrice;
    bool public isOpen;

    uint256 public subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;
    uint32 public numWords = 1;
    uint256 public lastRequestId;
    address public recentWinner;

    event LotteryOpened(uint256 ticketPrice);
    event PlayerEntered(address player);
    event RequestRandomness(uint256 requestId);
    event WinnerPicked(address winner, uint256 amount);
    event AdminTransferred(address previousAdmin, address newAdmin);

    constructor(
        address vrfCoordinator,
        uint256 _subscriptionId,
        bytes32 _keyHash,
        uint256 _ticketPrice
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        admin = msg.sender;
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        ticketPrice = _ticketPrice;
        isOpen = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function openLottery() external onlyAdmin {
        require(!isOpen, "Already open");
        delete players;
        isOpen = true;
        emit LotteryOpened(ticketPrice);
    }

    function enter() external payable {
        require(isOpen, "Lottery not open");
        require(msg.value == ticketPrice, "Incorrect ETH sent");
        players.push(msg.sender);
        emit PlayerEntered(msg.sender);
    }

    function endLottery() external onlyAdmin {
        require(isOpen, "Lottery not open");
        require(players.length > 0, "No players");
        isOpen = false;

        VRFV2PlusClient.RandomWordsRequest memory req = VRFV2PlusClient.RandomWordsRequest({
            keyHash: keyHash,
            subId: subscriptionId,
            requestConfirmations: requestConfirmations,
            callbackGasLimit: callbackGasLimit,
            numWords: numWords,
            extraArgs: VRFV2PlusClient._argsToBytes(
                VRFV2PlusClient.ExtraArgsV1({ nativePayment: false })
            )
        });

        uint256 requestId = s_vrfCoordinator.requestRandomWords(req);
        lastRequestId = requestId;
        emit RequestRandomness(requestId);
    }

    function fulfillRandomWords(uint256 , uint256[] calldata randomWords) internal override {
        uint256 r = randomWords[0];
        uint256 winnerIndex = r % players.length;
        address winner = players[winnerIndex];
        recentWinner = winner;
        uint256 prize = address(this).balance;

        (bool sent, ) = winner.call{value: prize}("");
        require(sent, "Transfer failed");

        emit WinnerPicked(winner, prize);
        delete players;
    }

    function getPlayersCount() external view returns (uint256) {
        return players.length;
    }

    receive() external payable {}
}
