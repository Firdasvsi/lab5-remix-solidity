/* eslint-disable no-undef */
import { ethers } from "hardhat";

// Наш заменитель для обхода блокировки VPN
const check = (actual) => ({
  to: {
    equal: (expected) => {
      if (actual.toString() !== expected.toString()) {
        throw new Error(`ОШИБКА: Ожидалось ${expected}, а получили ${actual}`);
      }
      console.log(`УСПЕХ: Значение ${actual} подтверждено.`);
    }
  }
});

describe("Ballot", function () {
  it("test vote and winner", async function () {
    // Подготовка имен кандидатов в формате bytes32
    const candidates = [
        ethers.utils.formatBytes32String("candidate_0"),
        ethers.utils.formatBytes32String("candidate_1")
    ];
    
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy(candidates);
    await ballot.deployed();
    console.log("Ballot развернут по адресу:" + ballot.address);

    const [chairman, acc_1] = await ethers.getSigners();

    // Даем право голоса и голосуем
    await ballot.giveRightToVote(acc_1.address);
    await ballot.connect(acc_1).vote(1); // Голосуем за второго кандидата (индекс 1)

    const winner = await ballot.winningProposal();
    check(winner).to.equal(1);
  });

  it("test delegate", async function () {
    const candidates = [
        ethers.utils.formatBytes32String("candidate_0"),
        ethers.utils.formatBytes32String("candidate_1")
    ];
    
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy(candidates);
    await ballot.deployed();

    const [chairman, acc_1, acc_2] = await ethers.getSigners();

    // Председатель дает право голоса Аккаунту 1
    await ballot.giveRightToVote(acc_1.address);
    // Аккаунт 1 передает свой голос Аккаунту 2
    await ballot.connect(acc_1).delegate(acc_2.address);
    // Аккаунт 2 (у которого теперь 2 голоса) голосует за индекс 1
    await ballot.connect(acc_2).vote(1);

    const winner = await ballot.winningProposal();
    check(winner).to.equal(1);
  });
});