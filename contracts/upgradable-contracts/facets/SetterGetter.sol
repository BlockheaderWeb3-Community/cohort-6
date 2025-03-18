// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract SetterGetter {
    LibAppStorage.Layout layout;

    function setName(string memory _name) external {
        layout.name = _name;
    }

    function setAge(uint8 _age) external {
        layout.age = _age;
    }

    function getName() external view returns (string memory name_) {
        name_ = layout.name;
        return name_;
    }

    function getAge() external view returns (uint8 age_) {
        age_ = layout.age;
        return age_;
    }
}
