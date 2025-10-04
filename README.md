# 🎲 CryptoPool – Decentralized Lottery Powered by Chainlink VRF v2 Plus

> **A provably fair on-chain lottery system** built using Solidity and Chainlink’s **Verifiable Random Function (VRF v2 Plus)**.  
> Ensures that winner selection is completely random, transparent, and tamper-proof.

---

## Overview

**Pool** is a decentralized lottery contract where:
- Users enter by paying a **ticket price in ETH**.
- The **admin** controls when to open or close the lottery.
- A random winner is chosen using **Chainlink VRF v2 Plus**, ensuring trustless randomness.
- The **entire pool balance** is automatically sent to the winner.

---

## Features

**Decentralized & verifiable randomness** via Chainlink VRF  
**Automated winner selection** — no manual bias possible  
**Transparent event logs** for all actions  
**Admin-controlled** lifecycle (open, end, draw)  
**Fair ETH prize distribution** to the winner  

---

## Contract Structure

| Variable | Description |
|-----------|--------------|
| `admin` | Address of the lottery administrator |
| `players` | List of all current participants |
| `ticketPrice` | Price (in wei) required to enter |
| `isOpen` | Status of lottery (open/closed) |
| `subscriptionId` | Chainlink VRF subscription ID |
| `keyHash` | Gas lane key hash for VRF |
| `callbackGasLimit` | Gas limit for VRF callback |
| `requestConfirmations` | Number of confirmations before VRF response |
| `numWords` | Number of random words requested |
| `lastRequestId` | Stores last Chainlink VRF request ID |
| `recentWinner` | Address of the most recent lottery winner |

---

## Smart Contract Logic

| Stage | Description |
|--------|--------------|
| ** Open Lottery** | Admin opens the lottery for participation |
| ** Enter Lottery** | Players join by paying the ticket price |
| ** End Lottery** | Admin ends lottery & requests randomness |
| ** Chainlink VRF** | Returns provably random number |
| ** Winner Picked** | Random winner gets all ETH in the pool |

---
