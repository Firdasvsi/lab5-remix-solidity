/* eslint-disable no-undef */
import { ethers } from "hardhat";

// Наш заменитель для обхода блокировки VPN
const check = (actual) => ({
  to: {
    equal: (expected) => {
      if (actual.toLowerCase() !== expected.toLowerCase()) {
        throw new Error(`ОШИБКА: Ждали адрес ${expected}, а получили ${actual}`);
      }
      console.log(`УСПЕХ: Адрес ${actual} совпадает.`);
    }
  }
});

describe("Owner", function () {
  it("test contract owner", async function () {
    const [acc_0] = await ethers.getSigners();
    const Owner = await ethers.getContractFactory("Owner");
    const owner = await Owner.deploy();
    await owner.deployed();
    
    console.log("Owner deployed at: " + owner.address);
    const currentOwner = await owner.getOwner();
    check(currentOwner).to.equal(acc_0.address);
  });

  it("test change owner", async function () {
    const [acc_0, acc_1] = await ethers.getSigners();
    const Owner = await ethers.getContractFactory("Owner");
    const owner = await Owner.deploy();
    await owner.deployed();
    
    await owner.changeOwner(acc_1.address);
    const newOwner = await owner.getOwner();
    check(newOwner).to.equal(acc_1.address);
  });
});