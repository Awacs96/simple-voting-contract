# Czech-style voting contract

<p align="center">
    <img width="300" height="300" src="./img/vote-box.png">
</p>


This contract is supposed to simulate voting system as there is in Czechia. The system considers political parties (and potentially groups of parties called coalitions), that compete for the largest possible share of casted votes. The difference between a party and a coalition is the minimun threshold coalition has to cross. 

# Basic rules of the vote

Quorum:
<ol>
    <li>Single policital party: >= 5% of all casted votes</li>
    <li>Coalition of 2 political parties: >= 8% of all casted votes</li>
    <li>Coalition of 3 or more parties: >= 11% of all casted votes</li>
</ol>

Other parties are ineligible for a seat in the Chamber of Deputies of the Czech Parliament.

Usually, voters may select several candidates on the ballot, however this functionality is not implemented in this version of the project.

# Process of counting the winner

Once the vote concludes, the ballots are counted up. For each subject (party or a coalition), the number of votes is added up and then divided by the overall number of valid ballots casted. If the party crosses the threshold, it will be awarded seats in the Chamber of Deputies. If not, the party is out of the race for seats. Once the results are counted and ineligible parties are out, there is a process of awarding the seats. This process runs similar logic. The Chamber has 200 seats that are awarded based on the following system.

# From votes to seats

The total number of of casted votes (CV) divided by the number of seats (S) will put together a (rounded up) number called "Overall mandate number" (MN). This number represents the average number of votes per one deputy. At this phase, the Czech system considers individual districts and political parties representation in them. But we will consider all parties to be represented by one single ballot for the whole country.

IF CV % S > 0 THEN MN = CV // S + 1 ELSE MN = CV // S

In the first phase, we divide the number of votes of the given party by the MN. We then save the remainder and do the same for the remaining eligible parties. It is likely there will remain undivided seats (maximum number of such seats is # of eligible parties - 1). This is where the reminder comes into play. The remaining seats will be distributed to the parties with largest remainder one at a time, where the party with the lowest remainder will be ommited. Since the system is adjusted so that there is no difference for any district nor a party for the MN number, this seems to be the most efficient method

An additional feature that should be implemented as well is, when two parties have a same reminder (we will be using decimals to represent the reminder). Should such situation occur, in the first instance a keccak hash of several values will be used to determine a party that will receive the last seat. In the following update, I would like to implement an oracle to to ensure higher level of randomness but since such situations (given the size of the system) should be rather rare, and since this would affect 1 seat out of 200, the current implementation does not require such advanced techique.

* Note: the total number of casted votes includes all votes casted, including votes casted for parties that did not cross the threshold.

# Limitations of the contract

The contract is able to accomodate the natural limit, which would be 27 parties (that would mean 9 coalitions as they have on average lower threshold per party and should such situation occur, 9 coalitions may be accomodated given a precise voting that would total up to 99% of all casted votes). 

# Ambition and disclaimer

Primary ambition is to show off ... honestly :D Just want to demonstrate my ability to work with Solidity as a coding language and also show some skills designing the contract, testing it and making it gas-efficient and secure. This does not mean the contract should be used on-chain! Never use copied code from the internet without auditing it!
