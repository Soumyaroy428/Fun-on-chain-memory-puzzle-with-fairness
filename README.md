# 🧩 Fair On-Chain Puzzle: A Beginner's Dive into Solidity

> <img width="1920" height="1020" alt="Screenshot 2025-10-29 140213" src="https://github.com/user-attachments/assets/286f02f9-c494-4859-b61c-649fb066a5c8" />


## 📜 Project Description

**Fair On-Chain Puzzle** is a Solidity-based smart contract that brings a classic memory matching game to the blockchain.  
Unlike traditional games where hidden data lives on a central server, this game embraces **blockchain transparency** — every move, every shuffle, every card is publicly verifiable.

This project demonstrates one of the most fundamental truths of blockchain development:  
> 🧠 **Nothing on-chain is truly private.**  
Even “private” variables can be read from storage — so fairness must be **provable**, not **promised**.

This project is designed for **beginners learning Solidity** and wanting hands-on experience with randomness, events, and game logic on-chain.

---

## 🎮 What It Does

- When a player starts a game, a **16-card board** is generated using a **pseudo-random shuffle** (Fisher–Yates algorithm).  
- The player flips cards by calling `flipCard(uint8 _index)` to reveal pairs and test their memory.  
- Each flip and match is logged via **events**, making the game state transparent for any connected frontend or blockchain explorer.  
- When all pairs are matched, the contract emits a **GameWon** event and cleans up storage to refund gas.

Everything — from board creation to turn management — happens **on the blockchain**, with full transparency and traceability.

---

## ✨ Features

| Feature | Description |
|----------|-------------|
| 🎲 **Fair-ish Shuffle** | Uses `keccak256` with block data and player input to create a unique 16-card layout per game. |
| 🔐 **On-Chain State Management** | Stores the board, matched pairs, and turn data on-chain — no hidden logic. |
| 🔄 **Turn Logic** | Handles both first and second flips automatically, checking for matches. |
| 🏆 **Auto Win Detection** | Detects when all 8 pairs are matched, emits `GameWon`, and deletes game data to refund gas. |
| 📡 **Event-Driven Updates** | Emits `GameStarted`, `Flip`, `MatchFound`, `NoMatch`, and `GameWon` events for seamless UI integration. |
| 💡 **Educational Value** | Perfect for beginners learning Solidity, randomness, and transparency principles. |

---

## 🔗 Deployed Smart Contract Link

You can view, compile, and deploy the contract directly using **Remix IDE** here:  
👉 [**Open in Remix**]
(https://remix.ethereum.org/#lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.30+commit.73712a01.js)
]
---


## 🧩 How to Play (in Remix)

1. **Open Remix** using the link above.  
2. Create a new file named `SimpleMemoryPuzzle.sol` and paste the contract code.  
3. Go to the **Solidity Compiler** tab and compile the contract.  
4. Under the **Deploy & Run Transactions** tab:  
   - Enter any random number (e.g., `123`) for `_salt`.  
   - Click **Deploy**.  
5. Use `flipCard(uint8 _index)` to flip cards from index `0` to `15`.  
6. Watch the **logs** for events like `MatchFound`, `NoMatch`, or `GameWon`.  
7. Call `getBoard()` anytime to “peek” at the full shuffled board — demonstrating blockchain transparency.

---

## ⚙️ Tech Stack

- **Solidity v0.8.30**  
- **Remix IDE** (for compiling and deploying)  
- **EVM-Compatible Network** (Ethereum testnet recommended)  

Optional extensions:
- **ethers.js / web3.js** for frontend integration  
- **React / Vue** for UI rendering and event listening  

---

## 🚀 Future Enhancements

- Integrate **Chainlink VRF** for secure randomness.  
- Build a **React frontend** with real-time event listening.  
- Add **leaderboards** or **multi-player logic** for competitive play.  
- Optimize for **gas efficiency** using storage packing or bitwise operations.

---

## ⚠️ Disclaimer

> **This project is for educational purposes only.**  
The randomness used here is **pseudo-random** and **not suitable** for real-money or gambling applications.  
Miners can influence block data, making outcomes predictable under certain conditions.  
For real applications, use **Chainlink VRF** or another secure randomness oracle.

---

## 🧠 Author’s Note

This project was built to help new blockchain developers understand:
- Why true randomness is difficult on-chain.
- How “fairness” works in public ledgers.
- The importance of provable, transparent systems.

---

**Made with ❤️ for learners exploring the world of Solidity and blockchain fairness.**
