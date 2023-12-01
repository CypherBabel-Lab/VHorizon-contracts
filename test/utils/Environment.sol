// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import { IDeployment } from "../interfaces/IDeployment.sol";
import { Deployment } from "./Deployment.sol";
import { Constants } from "./Constants.sol";


contract Environment is Deployment, Constants {

    IDeployment.VaultFactoryConf public vaultFactoryConf;

    function setUp() public {
        setUpMainnetEnvironment();
    }

    function setUpMainnetEnvironment() internal {
        string memory MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
        vm.createSelectFork(MAINNET_RPC_URL);
        setUpEnvironment(
            ETHEREUM_WETH,
            ETHEREUM_ETH_USD_AGGREGATOR,
            CHAINLINK_STALE_RATE_THRESHOLD
        );

    }

    function setUpEnvironment(
        address weth,
        address ethUsdAggregator,
        uint256 chainlinkStaleRateThreshold
    ) private {
        vm.label(weth, "WETH");
        vaultFactoryConf = deployRelease(weth, ethUsdAggregator, chainlinkStaleRateThreshold);
    }
}