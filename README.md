# 🚀 How to run the project

## 📦 Prerequisites

- Node.js v18.18.2+
- npm v9.8.1+
- Make sure you have installed [foundry](https://github.com/foundry-rs/foundry) on your machine.

## 🔆 Deploy smart contracts

### Step 1. Clone the repository

Note: the smart contracts and frontend are located in two repositories, please use the correct one.

```bash
git clone [GIT_REPOSITORY_URL] --recursive
```

### Step2. Go to the directory
```bash
cd [Project Name]
```

### Step 3. Create your `.env` file by copying `.env.example`

There is a private key of a wallet with a positive balance, with which you can deploy the smart contracts directly.

```bash
cp .env.example .env
```

You can also use your wallet on the TomoChain TestNet by setting `PRIVATE_KEY` in the `.env` file.


### Step 4. Deploy Uniswap V2 on the TomoChain TestNet

(1) Build the project.
```bash
forge build
```

(2) Find the "init code hash". It is the `bytecode`'s `object` in `out/UniswapV2Pair.sol/UniswapV2Pair.json`.

(3) Format the object using an online tool: https://emn178.github.io/online-tools/keccak_256.html. Choose `Hex` as the input type and `Hash` as the output type. Copy the bytecode located in (2) into the input box and delete the `0x` at the beginning.

(4) Replace the init code hash in `lib/uniswapv2/src/libraries/UniswapV2Library.sol`, line 26) with the output of (3).

(5) Deploy the Uniswap V2 on the TomoChain TestNet.
```bash
forge script ./script/UniswapV2Deploy.s.sol --skip-simulation --rpc-url https://rpc.testnet.tomochain.com --broadcast --slow -vvv
```

(6) Remember the three addresses (`wnativetoken address`, `factory address`, and `router address`) shown in `===Logs===` in the console. They will be used later.

### Step 5. Deploy test environment, including ERC20 test tokens, Uniswap V2 liquidity pools, and mocked Chainlink V3's price feed.

(1) Replace `UNISWAP_V2_ROUTER_02` in `script/EnvironmentDeploy.s.sol` (line 14) with the `router address` in Step 4's (6).

(2) Deploy the corresponding contracts
```bash
forge script ./script/EnvironmentDeploy.s.sol --skip-simulation --rpc-url https://rpc.testnet.tomochain.com --broadcast --slow -vvv
```

(3) Remember nine addresses shown in `===Logs===` in the console: `erc20WBTCAddress`, `erc20WETHAddress`, `erc20WSOLAddress`, `erc20DAIAddress`, `btcUsdAggregatorAddress`, `ethUsdAggregatorAddress`, `solEthAggregatorAddress`, `daiUsdAggregatorAddress`, and `wNativeTokenUsdAggregatorAddress`. They will be used later.

(4) Replace `WNATIVE_TOKEN` with `wnativetoken address` in `script/VaultFactoryDeploy.s.sol`.

(5) Replace `WNATIVE_TOKEN_USD_AGGREGATOR` with `wNativeTokenUsdAggregatorAddress` in `script/VaultFactoryDeploy.s.sol`.

(6) Replace `WBTC`, `WETH`, `WSOL`, and `DAI` with `erc20WBTCAddress`, `erc20WETHAddress`, `erc20WSOLAddress`, and `erc20DAIAddress` in `script/VaultFactoryDeploy.s.sol`, respectively.

(7) Replace `BTC_USD_AGGREGATOR`, `ETH_USD_AGGREGATOR`, `SOL_ETH_AGGREGATOR`, and `DAI_USD_AGGREGATOR` with `btcUsdAggregatorAddress`, `ethUsdAggregatorAddress`, `solUsdAggregatorAddress`, and `daiUsdAggregatorAddress` in `script/VaultFactoryDeploy.s.sol`. 

(8) Deploy test environment.
```bash
forge script ./script/VaultFactoryDeploy.s.sol --skip-simulation --rpc-url https://rpc.testnet.tomochain.com --broadcast --slow -vvv
```

### Step 6. Deploy Uniswapv2 adapter.

(1) Remember the address shown in `===Logs===` in the console: `integrationManagerAddress`.

(2) Replace `IntergrationManagerAddress`, `UNISWAP_V2_FACTORY`, and `UNISWAP_V2_ROUTER_02` with `integrationManagerAddress`, `factory address`, and `router address` respectively (`factory address`, and `router address` are in the first log).

(3) Deploy.
```bash
forge script ./script/AdapterDeploy.s.sol --skip-simulation --rpc-url https://rpc.testnet.tomochain.com --broadcast --slow -vvv
```

------

## 🔆 Test smart contracts

```bash
forge test
```

You can also manually run parts of the test suite, e.g:
```bash
forge test --match-test <REGEX>
```

Note: if the test is failed with `Could not instantiate forked environment with fork url`, please find a valid node of the Ethereum Mainnet and change `ETHEREUM_NODE_MAINNET` in `.env`.
