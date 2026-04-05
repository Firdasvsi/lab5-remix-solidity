// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; 
import "../contracts/1_Storage.sol";

contract StorageTest {
    Storage storageToTest;

    function beforeAll () public {
        storageToTest = new Storage();
    }

    function checkWriteRead () public {
        storageToTest.store(42);
        // Assert - это встроенная библиотека Remix для проверок
        Assert.equal(storageToTest.retrieve(), uint(42), "Value should be 42");
    }
}