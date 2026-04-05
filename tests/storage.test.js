/* eslint-disable no-undef */
import { ethers } from "hardhat";

// Мы создали свою функцию проверки, чтобы не зависеть от внешних библиотек и VPN
const check = (actual) => ({
  to: {
    equal: (expected) => {
      if (actual.toString() !== expected.toString()) {
        throw new Error(`ОШИБКА: Ждали ${expected}, а получили ${actual}`);
      }
      console.log(`УСПЕХ: Значение ${actual} верно.`);
    }
  }
});

describe("Storage", function () {
  it("test initial value", async function () {
    const Storage = await ethers.getContractFactory("Storage");
    const storage = await Storage.deploy();
    await storage.deployed();
    console.log("Контракт развернут по адресу: " + storage.address);
    
    const val = await storage.retrieve();
    check(val.toNumber()).to.equal(0);
  });

  it("test updating and retrieving updated value", async function () {
    const Storage = await ethers.getContractFactory("Storage");
    const storage = await Storage.deploy();
    await storage.deployed();
    
    const storage2 = await ethers.getContractAt("Storage", storage.address);
    const setValue = await storage2.store(56);
    await setValue.wait();
    
    const val = await storage2.retrieve();
    check(val.toNumber()).to.equal(56);
  });
});