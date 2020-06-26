pragma solidity ^0.6.10;

// 最初の一歩！
contract HelloSolidity {
    string public message;

    function set_msg (string _message) public {
        message = _message;
    }
}
