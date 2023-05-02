// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UMMAtoken is ERC20 {

    constructor() ERC20("UMMA Token", "UMMA") {
        _mint (msg.sender, 50000000000*10**18);
    }
}


                /*********************************************************
                  Proudly Developed by MetaIdentity ltd. Copyright 2023
                **********************************************************/
