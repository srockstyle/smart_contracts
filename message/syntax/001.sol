pragma solidity ^0.4.25;

contract hello_ethereum {
    string public message;

    function set_msg (string _message) public {
        message = _message;
    }
}
