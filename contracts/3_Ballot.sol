// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Реализация голосования с возможностью делегирования
 */
contract Ballot {

    struct Voter {
        uint weight; // вес голоса (дает председатель)
        bool voted;  // если истинно, то этот человек уже проголосовал
        address delegate; // человек, которому делегирован голос
        uint vote;   // индекс проголосованного предложения
    }

    struct Proposal {
        bytes32 name;   // короткое имя (до 32 байт)
        uint voteCount; // количество накопленных голосов
    }

    address public chairperson;

    // Сопоставление адреса с данными избирателя
    mapping(address => Voter) public voters;

    // Массив предложений (кандидатов)
    Proposal[] public proposals;

    /** 
     * @dev Создает новый бюллетень для выбора одного из предложений.
     * @param proposalNames список имен предложений
     */
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    /** 
     * @dev Дает право голоса избирателю. Может вызываться только председателем.
     * @param voter адрес избирателя
     */
    function giveRightToVote(address voter) external {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /** 
     * @dev Делегируйте свой голос другому избирателю.
     * @param to адрес, которому делегируется голос
     */
    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    /** 
     * @dev Отдайте свой голос за предложение.
     * @param proposal индекс предложения в массиве proposals
     */
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    /** 
     * @dev Вычисляет победившее предложение.
     */
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /** 
     * @dev Возвращает имя победителя.
     */
    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}