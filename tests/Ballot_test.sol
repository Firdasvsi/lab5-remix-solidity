// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // этот импорт Remix добавит сам при запуске
import "../contracts/3_Ballot.sol";

contract BallotTest {
    bytes32[] proposalNames;
    Ballot ballotToTest;

    // Выполняется один раз перед всеми тестами
    function beforeAll () public {
        proposalNames.push(bytes32("candidate1"));
        ballotToTest = new Ballot(proposalNames);
    }

    // Проверяем обычное голосование
    function checkWinningProposal () public {
        ballotToTest.vote(0);
        Assert.equal(ballotToTest.winningProposal(), uint(0), "proposal at index 0 should be the winning proposal");
        Assert.equal(ballotToTest.winnerName(), bytes32("candidate1"), "candidate1 should be the winner name");
    }

    // Проверяем возвращаемое значение функции
    function checkWinninProposalWithReturnValue () public view returns (bool) {
        return ballotToTest.winningProposal() == 0;
    }
}