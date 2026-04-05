/* eslint-disable no-undef */
import { ethers } from "hardhat";

// Наш заменитель для обхода блокировки VPN
const check = (actual) => ({
  to: {
    equal: (expected) => {
      if (actual.toString() !== expected.toString()) {
        throw new Error(`ОШИБКА: Ждали ${expected}, а получили ${actual}`);
      }
      console.log(`УСПЕХ: Значение ${actual} подтверждено.`);
    }
  }
});

describe("VendingMachine", function () {
  it("test payable method", async function () {
    const VendingMachine = await ethers.getContractFactory("VendingMachine");
    const vending = await VendingMachine.deploy();
    await vending.deployed();
    console.log("VendingMachine развернут по адресу: " + vending.address);

    const [owner, acc_1] = await ethers.getSigners();

    // 1. Проверяем начальный баланс (должно быть 100)
    check(await vending.getVendingMachineBalance()).to.equal(100);

    // 2. Покупаем 1 пончик за 1 Gwei (1e9 wei)
    await vending.connect(acc_1).purchase(1, {value: 1000000000});

    // 3. Проверяем, что осталось 99
    check(await vending.getVendingMachineBalance()).to.equal(99);
  });

  it("test refill", async function () {
    const VendingMachine = await ethers.getContractFactory("VendingMachine");
    const vending = await VendingMachine.deploy();
    await vending.deployed();

    const [owner, acc_1] = await ethers.getSigners();

    // 1. Покупаем 1 пончик
    await vending.connect(acc_1).purchase(1, {value: 1000000000});
    check(await vending.getVendingMachineBalance()).to.equal(99);

    // 2. Владелец пополняет баланс на 1
    await vending.refill(1);

    // 3. Проверяем, что снова 100
    check(await vending.getVendingMachineBalance()).to.equal(100);
  });
});