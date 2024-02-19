# Aussie voting contract

![Vote box image](./img/vote-box.png)

## Simple Voting Contract

This contract is supposet to simulate so-called "Instant-runnof voting" system. This voting system (used in several countries including the UK, the US and Australia) works on a principle of ranking individual candidates from 1 to the number of candidates participating.

# Basic rules of the vote

Any candidate that receives majority of the votes wins. Each voter has to mark at least its #1 preference (other places - co-called `alternative` votes can be left blank). The process of distributing the votes is described below. However, to win the vote, the candidate has to receive over 50% if the casted votes. That means that only one candidate emerges as victorious from this vote.

# Process of counting the winner

As stated above, winner is the one candidate receiving over 50% of all valid, casted votes (1 voter = 1 vote, the amount of preferences on an individual ballot does not make any difference). First, each candidate is assigned the number of votes that listed them as #1. Based on this count, if one candidate reaches majority, it wins the vote. If not, the last candidate is eliminated and its votes are distributed based on the preferences of the ballots of the eliminated candidate. This process is repeated until one candidate receives over 50% of the votes or until only one candidate remains.

# Diagram

 ------------------------------------
|    Candidate first choice count    |
 ------------------------------------
                  |
                  |  <-----------------------------------|
                  |                                      |
                  V                                      |
                 /  \                                    |
                /    \                                   |
               /      \                                  |
              /  Does  \                                 |
             /   one    \                                |
            /  candidate \       NO        -------------------------------
            \  have over / ------------ > |  Eliminate last place         |
             \    50%   /                 |  candidate, distribute votes  |
              \        /                   -------------------------------
               \      /
                \    /
                 \  /
                  |
                  | YES
                  |
                  V
        ---------------------
       |       WINNER        |           
        ---------------------

# Ambition and disclaimer

Primary ambition is to show off ... honestly :D Just want to demonstrate my ability to work with Solidity as a coding language and also show some skills designing the contract, testing it and making it gas-efficient and secure. This does not mean the contract should be used on-chain! Never use copied code from the internet without auditing it!
