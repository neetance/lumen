// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IQuoter} from "@uniswapV3-periphery/interfaces/IQuoter.sol";

contract PriceFetcher {
    IQuoter public quoter;

    constructor(address _quoter) {
        quoter = IQuoter(_quoter);
    }
}
