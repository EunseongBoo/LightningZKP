# LightningZKP

This project is for low-cost and fast Zero Kwolege Proof on Ethereum chain.
Users can send their ERC-20 tokens to another user anonymously.
This project is based on ["optimistic-zkdai" project](https://github.com/atvanguard/optimistic-zkdai#optimistic-zkdai).

I ported the ["optimistic-zkdai" project](https://github.com/atvanguard/optimistic-zkdai#optimistic-zkdai). (solditity 0.4.25) to solidity 0.5.2, and some key features have been added for low-cost and fast ZKP.

1.
2.
3.





# Test

1. open a terminal and enter the below command.
ganache-cli --allowUnlimitedContractSize --gasLimit 900000000
// node --max-old-space-size=4096 /home/boo/.nvm/versions/node/v10.16.0/bin/ganache-cli --allowUnlimitedContractSize --gasLimit 900000000

2. open a new ternminal and enter the below command.
truffle develop

3. To get gas usage of each functions in LightningZKP, enter the below command.
test ./test/spendNotes.js
