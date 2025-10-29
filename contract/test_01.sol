// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Hardhat/Foundry console.log for easy debugging. Remove for production.
import "hardhat/console.sol";

/**
 * @title SimpleMemoryPuzzle
 * @author You
 * @notice A simple, on-chain "puzzle" contract for beginners.
 *
 * --- !! IMPORTANT BEGINNER CONCEPT: Public Data !! ---
 *
 * This contract demonstrates a "puzzle" but NOT a "memory" game in
 * the traditional sense.
 *
 * On a public blockchain like Ethereum, *all* contract data is PUBLIC.
 * Even `private` variables can be read by off-chain tools.
 *
 * This means our `board` array, once created, can be seen by anyone.
 * A player doesn't need "memory" – they can just read the board
 * from the contract and solve the puzzle.
 *
 * --- !! HOW WE CREATE "FAIRNESS" !! ---
 *
 * The "fairness" comes from the board's *generation*. We use a
 * pseudo-random shuffle based on block data and a user-provided `_salt`.
 * This shuffle is "fair-ish" because it's difficult for a player
 * or miner to predict the outcome.
 *
 * A *truly* fair and unpredictable shuffle would require an
 * "Oracle" (like Chainlink VRF), which is a more advanced topic.
 *
 * This contract is a great starting point to learn about state,
 * structs, mappings, and the fundamental limitations of the EVM.
 */
contract SimpleMemoryPuzzle {

    // --- Game Data Structure ---
    // We create a 'struct' to hold all the data for a single game.
    struct Game {
        address player;          // The address of the player.
        bool isActive;           // True if a game is in progress.
        uint8[16] board;         // The shuffled board (THIS IS PUBLIC DATA).
        uint8 pairsMatchedCount; // How many pairs the player has found (0-8).
        
        // This mapping tracks which *values* (1-8) have been found.
        mapping(uint8 => bool) pairsFound; 
        
        // --- Turn State ---
        // These variables track the player's current turn.
        uint8 firstCardIndex;
        bool isFirstCardFlipped; // True if the player has flipped one card and is waiting to flip the second.
    }

    // --- State Variables ---
    // This mapping stores one active game for each player's address.
    mapping(address => Game) public games;

    // --- Events ---
    // Events are important! They log data to the blockchain for
    // your website/app (client) to read.
    event GameStarted(address indexed player);
    event Flip(address indexed player, uint8 index, uint8 cardValue);
    event MatchFound(address indexed player, uint8 cardValue, uint8 index1, uint8 index2);
    event NoMatch(address indexed player, uint8 index1, uint8 index2);
    event GameWon(address indexed player);
    event GameReset(address indexed player);

    /**
     * @notice Starts a new game for the player (msg.sender).
     * @param _salt A random number from the player to help with shuffling.
     *
     * This function creates a new, shuffled board and saves it to
     * the player's game storage.
     */
    function startGame(uint256 _salt) external {
        // Get a reference to the player's game in storage.
        Game storage game = games[msg.sender];
        
        // Disallow starting a new game if one is already in progress.
        require(!game.isActive, "You already have a game in progress. Call resetGame() first.");

        // 1. Create the base board (8 pairs, values 1-8)
        uint8[16] memory baseBoard = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8];

        // 2. Create a "fair-ish" pseudo-random seed.
        // We combine block timestamp, the player's address, and their salt.
        // This is not truly random, but it's good for a simple game.
        uint256 randomSeed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _salt)));

        // 3. Fisher-Yates Shuffle Algorithm
        // This loop shuffles the baseBoard in place.
        for (uint8 i = 15; i > 0; i--) {
            uint8 j = uint8(randomSeed % (i + 1));
            randomSeed /= (i + 1);
            
            // Swap elements
            (baseBoard[i], baseBoard[j]) = (baseBoard[j], baseBoard[i]);
        }

        // 4. Save the new game state to storage
        game.board = baseBoard;
        game.player = msg.sender;
        game.isActive = true;
        game.pairsMatchedCount = 0;
        game.isFirstCardFlipped = false;
        
        // Note: The `pairsFound` mapping is already all `false` by default.

        emit GameStarted(msg.sender);
    }

    /**
     * @notice Flips a card at a given index (0-15).
     * This function holds the main game logic for matching.
     */
    function flipCard(uint8 _index) external {
        Game storage game = games[msg.sender];
        
        // --- Checks ---
        require(game.isActive, "You do not have an active game.");
        require(_index < 16, "Index must be between 0 and 15.");

        uint8 cardValue = game.board[_index];
        
        // Check if this pair (e.g., all "5s") is already matched.
        require(!game.pairsFound[cardValue], "This pair has already been matched.");
        
        // Check if they are flipping the *same* card twice in one turn.
        if (game.isFirstCardFlipped) {
            require(game.firstCardIndex != _index, "Cannot flip the same card twice.");
        }

        emit Flip(msg.sender, _index, cardValue);
        console.log("Player %s flipped index %s (value %s)", msg.sender, _index, cardValue);

        if (!game.isFirstCardFlipped) {
            // --- This is the FIRST card of the turn ---
            game.firstCardIndex = _index;
            game.isFirstCardFlipped = true;
        } else {
            // --- This is the SECOND card, check for a match ---
            uint8 firstCardValue = game.board[game.firstCardIndex];
            
            if (firstCardValue == cardValue) {
                // --- IT'S A MATCH! ---
                game.pairsFound[cardValue] = true;
                game.pairsMatchedCount++;
                emit MatchFound(msg.sender, cardValue, game.firstCardIndex, _index);
                console.log("Match found for value %s", cardValue);

                if (game.pairsMatchedCount == 8) {
                    // --- GAME WON! ---
                    emit GameWon(msg.sender);
                    // Clean up the game state to save gas
                    delete games[msg.sender];
                }
            } else {
                // --- NO MATCH ---
                emit NoMatch(msg.sender, game.firstCardIndex, _index);
                console.log("No match.");
            }

            // Reset for the next turn
            game.isFirstCardFlipped = false;
        }
    }
    
    /**
     * @notice Allows a player to reset their game if they are stuck
     * or want to start over.
     */
    function resetGame() external {
        // `delete` resets the struct to its default (empty) values.
        delete games[msg.sender];
        emit GameReset(msg.sender);
    }

    // --- View Functions (for your website/app) ---
    // View functions are 'read-only' and do not cost any gas to call.

    /**
     * @notice Lets your app see the player's full, shuffled board.
     */
    function getBoard() external view returns (uint8[16] memory) {
         Game storage game = games[msg.sender];
         require(game.isActive, "No active game.");
         return game.board;
    }

    /**
     * @notice Lets your app check if a specific pair (e.g., "7")
     * has been found yet.
     */
    function hasPairBeenFound(uint8 _cardValue) external view returns (bool) {
        Game storage game = games[msg.sender];
        require(game.isActive, "No active game.");
        return game.pairsFound[_cardValue];
    }
    
    /**
     * @notice A helper to get the full game state for your UI.
     */
    function getGameStatus() external view returns (bool isActive, uint8 pairsMatched, bool isFirstCardFlipped) {
        Game storage game = games[msg.sender];
        return (
            game.isActive,
            game.pairsMatchedCount,
            game.isFirstCardFlipped
        );
    }
}

