pragma solidity ^0.5.0;
// SPDX-License-Identifier: UNLICENSED>
contract TestString {

    //メソッド
    string public text = 'show me';
    function test() public view returns (string memory) {
        return text;
    }
}
