// SPDX-License-Identifier: MIT

// 0.8.20 이상의 solidity로 컴파일한다
pragma solidity ^0.8.20;

// ERC20을 이 파일에서 쓰기 위해서 리맵핑 작업 (ERC20만 해당 파일에서 가져옴)
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HaneulCoin is ERC20 {
    constructor() ERC20("HaneulCoin", "HNL") {
        _mint(msg.sender, 100_000 * 10 ** decimals());
    }
}
