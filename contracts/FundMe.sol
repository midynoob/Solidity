// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 2 * 1e18;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversion() > minimumUsd, "Didnt Send Enough, Should be greater than 20 USD" );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    

    function withdraw() public onlyOwner {

        

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        } 
        funders = new address[](0);


        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        //call
        // (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send Failed");
    }


    modifier onlyOwner {
        require(msg.sender == owner, "Sender is not Owner");
        _;
    }

}