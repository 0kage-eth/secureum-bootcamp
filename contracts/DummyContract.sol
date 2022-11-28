//SPDX-License-Identifier:MIT
pragma solidity 0.8.9;  
import "./TestContract.sol";

contract DummyContract {

    TestContract private test;
    ITestContract private testInterface;

    function test() external view returns(bool){

        // bytes memory creationCode = test.
        // return true;
    }

}