// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; 
import "../contracts/4_VendingMachine.sol";

contract VendingMachineTest {
    VendingMachine machineToTest;

    // Подготовка перед тестами
    function beforeAll () public {
        machineToTest = new VendingMachine();
    }

    // Тест начального запаса
    function checkInitialBalance () public {
        Assert.equal(machineToTest.getVendingMachineBalance(), uint(100), "Initial balance should be 100");
    }

    // Тест пополнения (refill)
    function checkRefill () public {
        machineToTest.refill(10);
        Assert.equal(machineToTest.getVendingMachineBalance(), uint(110), "Balance after refill should be 110");
    }
}