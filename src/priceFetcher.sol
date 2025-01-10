// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IQuoter} from "@uniswapV3-periphery/interfaces/IQuoter.sol";

contract PriceFetcher {
    enum Chain {
        ETHEREUM,
        ARBITRUM
    }

    enum ReqType {
        EXACT_INPUT_TO_OUTPUT,
        EXACT_OUTPUT_TO_INPUT
    }

    struct PriceFetcherParams {
        Chain chain;
        ReqType reqType;
        address tokenIn;
        uint256 amountIn;
        address tokenOut;
        uint256 amountOut;
        uint24 fee;
    }

    address public s_quoterEthereum;
    address public s_quoterArbitrum;

    constructor(address _quoterEthereum, address _quoterArbitrum) {
        s_quoterEthereum = _quoterEthereum;
        s_quoterArbitrum = _quoterArbitrum;
    }

    function getPrice(PriceFetcherParams memory params) external returns (uint256 price) {
        if (params.chain == Chain.ETHEREUM)
            price = getPrice(params, s_quoterEthereum);
        else if (params.chain == Chain.ARBITRUM)
            price = getPrice(params, s_quoterArbitrum);
        else
            revert("Invalid chain");
    }

    function getPrice(PriceFetcherParams memory params, address _quoter) internal returns (uint256) {
        IQuoter quoter = IQuoter(_quoter);

        if (params.reqType == ReqType.EXACT_INPUT_TO_OUTPUT)
            return quoter.quoteExactInputSingle(params.tokenIn, params.tokenOut, params.fee, params.amountIn, 0);
        else
            return quoter.quoteExactOutputSingle(params.tokenIn, params.tokenOut, params.fee, params.amountOut, 0);
    }
}
