// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract VendingMachine {
    address public owner;
    uint public donutBalances;

    constructor() {
        owner = msg.sender;
        donutBalances = 100; 
    }

    function refill(uint amount) public {
        require(msg.sender == owner, "Only the owner can refill.");
        donutBalances += amount;
    }

    function purchase(uint amount) public payable {
        // Проверяем, что оплата составила минимум 1 Gwei за пончик
        require(msg.value >= amount * 1e9, "You must pay at least 1 Gwei per donut");
        require(donutBalances >= amount, "Not enough donuts in stock");
        donutBalances -= amount;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances;
    }
}