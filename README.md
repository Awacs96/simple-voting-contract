# Czech-style voting contract

<p align="center">
    <img width="300" height="300" src="./img/vote-box.png">
</p>


This contract is supposed to simulate voting system as there is in Czechia. The system considers political parties (and potentially groups of parties called coalitions), that compete for the largest possible share of casted votes. The difference between a party and a coalition is the minimun threshold coalition has to cross. 

# Basic rules of the vote

Quorum:
<ol>
    <li>## Single policital party: >= 5% of all casted votes</li>
    <li>## Coalition of 2 political parties: >= 8% of all casted votes</li>
    <li>## Coalition of 3 or more parties: >= 11% of all casted votes</li>
</ol>

Other parties are ineligible for a seat in the Chamber of Deputies of the Czech Parliament.

Any candidate that receives majority of the votes wins. Each voter has to mark at least its #1 preference (other places - co-called `alternative` votes can be left blank). The process of distributing the votes is described below. However, to win the vote, the candidate has to receive over 50% if the casted votes. That means that only one candidate emerges as victorious from this vote.

# Process of counting the winner

As stated above, winner is the one candidate receiving over 50% of all valid, casted votes (1 voter = 1 vote, the amount of preferences on an individual ballot does not make any difference). First, each candidate is assigned the number of votes that listed them as #1. Based on this count, if one candidate reaches majority, it wins the vote. If not, the last candidate is eliminated and its votes are distributed based on the preferences of the ballots of the eliminated candidate. This process is repeated until one candidate receives over 50% of the votes or until only one candidate remains.

# Diagram

```
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
```

# Limitations of the contract

Due to slightly complicated system, I decided to set limit to the number of candidates to 6. 

# Ambition and disclaimer

Primary ambition is to show off ... honestly :D Just want to demonstrate my ability to work with Solidity as a coding language and also show some skills designing the contract, testing it and making it gas-efficient and secure. This does not mean the contract should be used on-chain! Never use copied code from the internet without auditing it!
