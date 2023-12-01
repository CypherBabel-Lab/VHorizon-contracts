// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
// import { IVaultFactory } from "../src/vault-factory/IVaultFactory.sol";
// import { IValueEvaluator } from "./interfaces/IValueEvaluator.sol";
import { IWETH } from "../src/external-interfaces/IWETH.sol";
import { IERC20 } from "openzeppelin/token/ERC20/IERC20.sol";
import { IUniswapV2Router2 } from "../src/external-interfaces/IUniswapV2Router2.sol";

// uniswap v2 router 02 address
address constant UNISWAP_V2_ROUTER_02 = 0xB1C4C22FeE13DA89E8D983227d9dc6314E29894a;

contract EnvironmentDeploy is Script {

    address public deployerAddress;
    uint256 public deployerPrivateKey;

     function setUp() public {
      deployerPrivateKey = vm.envUint("PRIVATE_KEY");
      deployerAddress = vm.addr(deployerPrivateKey);
     }

     function run() public {
        vm.startBroadcast(deployerPrivateKey);
        // 部署erc20
        address erc20WBTCAddress = deployERC20("wbtc", "WBTC");
        console.log("erc20WBTCAddress",erc20WBTCAddress);
        address erc20WETHAddress = deployERC20("weth", "WETH");
        console.log("erc20WETHAddress",erc20WETHAddress);
        address erc20WSOLAddress = deployERC20("wsol", "WSOL");
        console.log("erc20WSOLAddress",erc20WSOLAddress);
        address erc20DAIAddress = deployERC20("dai", "DAI");
        console.log("erc20DAIAddress",erc20DAIAddress);
        // carete pair
        IUniswapV2Router2 uniswapV2Router2 = IUniswapV2Router2(UNISWAP_V2_ROUTER_02);
        uint256 erc20WBTCAddressAmount = 1000000000000000000 * 1000;
        uint256 erc20WETHAddressAmount = 1000000000000000000 * 10000;
        uint256 erc20WSOLAddressAmount = 1000000000000000000 * 100000;
        uint256 erc20DAIAddressAmount = 1000000000000000000 * 10000000;

        deployUniswapV2Pool(UNISWAP_V2_ROUTER_02, erc20WBTCAddress, erc20DAIAddress, erc20WBTCAddressAmount, erc20DAIAddressAmount);
        deployUniswapV2Pool(UNISWAP_V2_ROUTER_02, erc20WETHAddress, erc20DAIAddress, erc20WETHAddressAmount, erc20DAIAddressAmount);
        deployUniswapV2Pool(UNISWAP_V2_ROUTER_02, erc20WSOLAddress, erc20DAIAddress, erc20WSOLAddressAmount, erc20DAIAddressAmount);

        vm.stopBroadcast();
     }

     function deployERC20(string memory _name, string memory _symbol) public returns (address) {
        return deployCode("MyERC20.sol",abi.encode(_name,_symbol));
     }

     function deployUniswapV2Pool(address router02, address _tokenA, address _tokenB, uint256 _tokenAAmount, uint256 _tokenBAmount) public {
        IERC20(_tokenA).approve(router02, _tokenAAmount);
        IERC20(_tokenB).approve(router02, _tokenBAmount);
        (,,uint lp) = IUniswapV2Router2(router02).addLiquidity(_tokenA, _tokenB, _tokenAAmount, _tokenBAmount, _tokenAAmount, _tokenBAmount, deployerAddress, block.timestamp + 60);
        console.log("lp amount",lp);
     }
}