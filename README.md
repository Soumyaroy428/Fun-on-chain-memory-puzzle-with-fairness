🧩 Fun On-Chain Memory Puzzle

A simple and fair "memory puzzle" smart contract written in Solidity. This project is a perfect starting point for beginners to learn about state management, pseudo-randomness, and the core concepts of building a simple game on the Ethereum blockchain.

🚀 What It Does

This contract creates a 16-card (8 pairs) puzzle board for a player. The key is fairness: the board is generated with a pseudo-random shuffle that is difficult to predict.

Important Note for Beginners: This is a "puzzle" and not a true "memory" game. On a public blockchain, all data is public! This means anyone can read the contract's state to see the shuffled board. The "game" is to correctly call the flipCard function to match the pairs, and the "fairness" comes from the fact that the shuffle is provably random at the time of creation.

✨ Features

Fair Shuffle: Uses a pseudo-random shuffle (Fisher-Yates algorithm) based on block data and a user-provided salt to generate a unique board.

On-Chain Game State: The entire game (board, matched pairs, current turn) is managed by the smart contract.

Turn Logic: Correctly tracks the first and second card flips for a player's turn.

Win Condition: Detects when all 8 pairs have been matched and automatically cleans up the game state.

Events: Emits events for all major actions (GameStarted, Flip, MatchFound, NoMatch, GameWon) so a web frontend can easily listen and react.

Gas Efficient: Cleans up game state with delete upon game completion to refund gas.

🎮 How to Play

Call the startGame(uint256 _salt) function with any random number (your _salt). This will create and save your unique, shuffled game board.

Call the flipCard(uint8 _index) function with an index from 0 to 15 to flip your first card.

Call flipCard(uint8 _index) again with a different index for your second card.

The contract will automatically check for a match.

If it's a match, it will record the pair as "found."

If it's not a match, you just try again on your next turn.

Keep flipping until all 8 pairs are found and the GameWon event is emitted!

You can use the resetGame() function at any time to start over.

📄 Smart Contract Code

Here is the complete SimpleMemoryPuzzle.sol contract.

//paste your code


remix-ide Try it Live on Remix!

You can deploy, test, and interact with this contract directly in your browser using Remix.

🔗 Click here to open this contract in Remix

⚠️ Disclaimer

This contract is for educational purposes. The pseudo-randomness used is not secure enough for applications involving real money (like gambling). For true, unpredictable randomness, a more advanced solution like Chainlink VRF would be required.
