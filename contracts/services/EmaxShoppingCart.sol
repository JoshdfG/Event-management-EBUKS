// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../interface/IERC20.sol";
import "../library/ErrorMessage.sol";
import "../library/Events.sol";

contract EmaxShoppingCart {
    using ErrorMessage for *;
    using Events for *;

    //token address deployed
    address public tokenAddress;

    //nft address deployed
    address public nftAddress;

    //want to map an address to a bool to keep track if it is paid

    mapping(address => bool) public isPaid;

    //i want to be able to revieve a token and then from a user and change token and mint an nft for the user

    constructor(address _tokenAddress, address _nftAddress) {
        tokenAddress = _tokenAddress;
        nftAddress = _nftAddress;
    }

    //price of the nft for the user to pay
    uint public nftPrice = 10000;

    uint totalTokenAmount;

    function swapTokenForNft(uint _tokenAmount) external {
        if (_tokenAmount < nftPrice) {
            revert ErrorMessage.AMOUNT_SHOULD_BE_GREATER_THAN_10000();
        }
        ErrorMessage.ZERO_ADDRESS_CHECK(msg.sender);

        if (IERC20(tokenAddress).balanceOf(msg.sender) < _tokenAmount) {
            revert ErrorMessage.INSUFFICIENT_FUNDS();
        }

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokenAmount
        );
        isPaid[msg.sender] = true;

        mintNftAfterPayment(msg.sender);
        emit Events.SwapSuccessful(msg.sender, address(this), _tokenAmount);
    }

    function mintNftAfterPayment(address _userAddress) internal {
        IERC721(nftAddress).mint(_userAddress);
    }
}
