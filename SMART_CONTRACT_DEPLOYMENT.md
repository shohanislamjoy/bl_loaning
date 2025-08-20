# Smart Contract Deployment Guide

This guide will help you deploy the CreditScoring smart contract to Sepolia testnet.

## Option 1: Using Remix IDE (Recommended for beginners)

### Step 1: Open Remix IDE
1. Go to [https://remix.ethereum.org/](https://remix.ethereum.org/)
2. Create a new file named `CreditScoring.sol`

### Step 2: Paste Smart Contract Code
Copy and paste the following Solidity code:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CreditScoring {
    struct Borrower {
        string name;
        string profession;
        uint256 accountBalance;        // current balance
        uint256 totalTransactions;     // monthly freq * avg size proxy
        uint256 onTimePayments;        // count
        uint256 missedPayments;        // count
        uint256 totalRemainingLoan;    // current outstanding combined
        uint256 creditAgeMonths;       // age of credit history
        uint256 professionRiskScore;   // lower = safer (0..100)
        bool exists;
    }

    struct Loan {
        uint256 amount;
        uint256 paid;
        bool active;
    }

    mapping(bytes32 => Borrower) public borrowers;     // key = nid hash
    mapping(bytes32 => Loan) public loans;

    // weights from paper (Account 25, Txns 15, Payment 30, Remaining 10, Age 10, Prof 10)
    uint256 private constant W_ACCOUNT = 25;
    uint256 private constant W_TXNS = 15;
    uint256 private constant W_PAYMENT = 30;
    uint256 private constant W_REMAINING = 10;
    uint256 private constant W_AGE = 10;
    uint256 private constant W_PROF = 10;

    uint256 public creditThreshold = 500;  // demo threshold
    uint256 public maxScore = 1000;        // weighted to 1000 for simplicity

    event BorrowerAdded(bytes32 indexed nid, string name);
    event LoanRequested(bytes32 indexed nid, uint256 amount);
    event Repaid(bytes32 indexed nid, uint256 amount, uint256 totalPaid);

    function _nidKey(string memory nid) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(nid));
    }

    function addBorrower(
        string memory nid,
        string memory name,
        string memory profession,
        uint256 accountBalance,
        uint256 totalTransactions,
        uint256 onTimePayments,
        uint256 missedPayments,
        uint256 totalRemainingLoan,
        uint256 creditAgeMonths,
        uint256 professionRiskScore
    ) external {
        bytes32 key = _nidKey(nid);
        Borrower storage b = borrowers[key];
        b.name = name;
        b.profession = profession;
        b.accountBalance = accountBalance;
        b.totalTransactions = totalTransactions;
        b.onTimePayments = onTimePayments;
        b.missedPayments = missedPayments;
        b.totalRemainingLoan = totalRemainingLoan;
        b.creditAgeMonths = creditAgeMonths;
        b.professionRiskScore = professionRiskScore;
        b.exists = true;
        emit BorrowerAdded(key, name);
    }

    // --- Scoring helpers (toy but aligned with your paper's intent) ---
    function _scoreAccount(uint256 accountBalance) internal pure returns (uint256) {
        // Normalize to 0..100
        // Example scaling: >= 1,000,000 -> 100; 0 -> 0
        uint256 capped = accountBalance > 1_000_000 ? 1_000_000 : accountBalance;
        return (capped * 100) / 1_000_000;
    }

    function _scoreTxns(uint256 totalTransactions) internal pure returns (uint256) {
        // Assume totalTransactions is a proxy (freq*avg) scaled so 100 means strong activity
        uint256 capped = totalTransactions > 100 ? 100 : totalTransactions;
        return capped;
    }

    function _scorePayment(uint256 onTime, uint256 missed) internal pure returns (uint256) {
        uint256 total = onTime + missed;
        if (total == 0) return 50; // unknown history -> neutral
        return (onTime * 100) / total; // % on-time
    }

    function _scoreRemaining(uint256 remaining) internal pure returns (uint256) {
        // Lower remaining debt -> higher score
        if (remaining >= 1_000_000) return 0;
        return 100 - (remaining * 100 / 1_000_000);
    }

    function _scoreAge(uint256 months_) internal pure returns (uint256) {
        // >= 60 months => 100
        uint256 capped = months_ > 60 ? 60 : months_;
        return (capped * 100) / 60;
    }

    function _scoreProfession(uint256 risk) internal pure returns (uint256) {
        // risk 0 => 100, risk 100 => 0
        if (risk >= 100) return 0;
        return 100 - risk;
    }

    function calculateCreditScore(string memory nid) public view returns (uint256) {
        Borrower memory b = borrowers[_nidKey(nid)];
        require(b.exists, "Borrower not found");

        uint256 sAccount  = _scoreAccount(b.accountBalance);                 // 0..100
        uint256 sTxns     = _scoreTxns(b.totalTransactions);                 // 0..100
        uint256 sPayment  = _scorePayment(b.onTimePayments, b.missedPayments);
        uint256 sRemain   = _scoreRemaining(b.totalRemainingLoan);
        uint256 sAge      = _scoreAge(b.creditAgeMonths);
        uint256 sProf     = _scoreProfession(b.professionRiskScore);

        // weighted sum scaled to 1000 (sum weights = 100)
        uint256 total =
              sAccount  * W_ACCOUNT
            + sTxns     * W_TXNS
            + sPayment  * W_PAYMENT
            + sRemain   * W_REMAINING
            + sAge      * W_AGE
            + sProf     * W_PROF;

        return total / 10; // to 0..1000
    }

    function getCreditRating(string memory nid) external view returns (string memory) {
        uint256 score = calculateCreditScore(nid);
        if (score >= 800) return "A";
        if (score >= 650) return "B" ;
        if (score >= 500) return "C";
        return "D";
    }

    function getMaxLoanAmount(string memory nid, uint256 monthlyIncome) external view returns (uint256) {
        // Simple demo: multiplier from score; reduce by outstanding debt
        Borrower memory b = borrowers[_nidKey(nid)];
        require(b.exists, "Borrower not found");
        uint256 score = calculateCreditScore(nid); // 0..1000

        // multiplier ~ 0..5x income depending on score
        uint256 multiplier = 1 + (score * 4) / 1000; // 1x .. 5x
        uint256 base = monthlyIncome * multiplier;

        // Deduct some function of remaining loans
        if (b.totalRemainingLoan >= base) return 0;
        return base - b.totalRemainingLoan;
    }

    function requestLoan(string memory nid, uint256 amount) external {
        bytes32 key = _nidKey(nid);
        Borrower memory b = borrowers[key];
        require(b.exists, "Borrower not found");
        uint256 score = calculateCreditScore(nid);
        require(score >= creditThreshold, "Score below threshold");

        require(!loans[key].active, "Loan already active");
        loans[key] = Loan({amount: amount, paid: 0, active: true});
        emit LoanRequested(key, amount);
    }

    function repay(string memory nid) external payable {
        // demo: native-ETH repayment for simplicity
        bytes32 key = _nidKey(nid);
        Loan storage L = loans[key];
        require(L.active, "No active loan");
        L.paid += msg.value;
        emit Repaid(key, msg.value, L.paid);

        if (L.paid >= L.amount) {
            L.active = false;
        }
    }

    function getScoreBreakdown(string memory nid) external view returns (
        uint256 accountScore,
        uint256 txnScore,
        uint256 paymentScore,
        uint256 remainingScore,
        uint256 ageScore,
        uint256 professionScore
    ) {
        Borrower memory b = borrowers[_nidKey(nid)];
        require(b.exists, "Borrower not found");
        accountScore    = _scoreAccount(b.accountBalance);
        txnScore        = _scoreTxns(b.totalTransactions);
        paymentScore    = _scorePayment(b.onTimePayments, b.missedPayments);
        remainingScore  = _scoreRemaining(b.totalRemainingLoan);
        ageScore        = _scoreAge(b.creditAgeMonths);
        professionScore = _scoreProfession(b.professionRiskScore);
    }
}
```

### Step 3: Compile the Contract
1. Go to the "Solidity Compiler" tab
2. Select compiler version `0.8.20` or higher
3. Click "Compile CreditScoring.sol"

### Step 4: Connect to Sepolia
1. Go to the "Deploy & Run Transactions" tab
2. Set Environment to "Injected Provider - MetaMask"
3. Make sure MetaMask is connected to Sepolia testnet
4. Ensure you have Sepolia ETH in your wallet

### Step 5: Deploy
1. Select `CreditScoring` contract
2. Click "Deploy"
3. Confirm the transaction in MetaMask
4. **Copy the deployed contract address** from the console

### Step 6: Update Flutter App
Copy the contract address and update `lib/config/blockchain_config.dart`:

```dart
static const String contractAddress = '0xYOUR_DEPLOYED_ADDRESS_HERE';
```

## Option 2: Using Hardhat (Advanced)

### Step 1: Initialize Hardhat Project
```bash
mkdir credit-scoring-contract
cd credit-scoring-contract
npm init -y
npm install --save-dev hardhat
npx hardhat
```

### Step 2: Create Contract File
Create `contracts/CreditScoring.sol` with the contract code above.

### Step 3: Deploy Script
Create `scripts/deploy.js`:

```javascript
const hre = require("hardhat");

async function main() {
  const CreditScoring = await hre.ethers.getContractFactory("CreditScoring");
  const creditScoring = await CreditScoring.deploy();

  await creditScoring.deployed();

  console.log("CreditScoring deployed to:", creditScoring.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

### Step 4: Configure Hardhat
Update `hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID",
      accounts: ["YOUR_PRIVATE_KEY"]
    }
  }
};
```

### Step 5: Deploy
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## Getting Sepolia ETH

1. **Alchemy Faucet**: [https://sepoliafaucet.com/](https://sepoliafaucet.com/)
2. **Infura Faucet**: [https://www.infura.io/faucet](https://www.infura.io/faucet)
3. **Chainlink Faucet**: [https://faucets.chain.link/sepolia](https://faucets.chain.link/sepolia)

## Verification

After deployment, you can verify your contract on Etherscan:

1. Go to [https://sepolia.etherscan.io/](https://sepolia.etherscan.io/)
2. Search for your contract address
3. Verify the contract code for transparency

## Next Steps

1. Copy the deployed contract address
2. Update your Flutter app configuration
3. Test the blockchain functions
4. Monitor transactions on Etherscan

Your contract will be live on Sepolia testnet and ready for integration with the Flutter app!
