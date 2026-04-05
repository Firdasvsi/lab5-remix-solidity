// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; 
import "../contracts/2_Owner.sol";

contract OwnerTest {
    Owner ownerToTest;

    function beforeAll () public {
        // Создаем новый экземпляр контракта Owner
        ownerToTest = new Owner();
    }

    function checkInitialOwner () public {
        // Проверяем, что владельцем является адрес этого тестового контракта
        Assert.equal(ownerToTest.getOwner(), address(this), "Owner should be the test contract");
    }
}