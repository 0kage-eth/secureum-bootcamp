// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

contract TestContract {


    uint256 private counter = 5;

    function increaseCounter() external {
        require(counter < type(uint).max, "counter at max value");
        counter ++;
    }

    function decreaseCounter() external {
        require(counter > 0, "counter at min value");
        counter --;
    }

    function getCounter() external view returns(uint){
        return counter;
    }

}

interface ITestContract{
    function increaseCounter() external;
    function decreaseCounter() external; 
    function getCounter() external view returns(uint);
}


