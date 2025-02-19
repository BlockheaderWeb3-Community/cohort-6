// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry {
    /// **** Enums ****
    enum Attendance {
        Present,
        Absent
    }
    /// **** End of Enums ****

    /// **** Structs ****
    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }
    /// **** End of Structs ****

    /// ********** State variables **********
    mapping(address => Student) public students;
    address public owner;
    /// ********** End of State variables **********

    /// **** Events ****
    event StudentCreated(address _studentAddress, string _name);
    event AttendanceStatus(address _studentAddress, Attendance _attendance);
    event InterestAdded(address _studentAddress, string _interest);
    event InterestRemoved(address _studentAddress, string _interest);
    /// **** End of Events ****

    /// **** Constructor ****
    constructor() {
        owner = msg.sender;
    }
    /// **** End of Constructor ****

    /// **** Modifiers ****
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier studentExists(address _address) {
        require(bytes(students[_address].name).length > 0, "Student does not exist");
        _;
    }

    modifier studentDoesNotExist(address _address) {
        require(bytes(students[_address].name).length == 0, "Student already exists");
        _;
    }
    /// **** End of Modifiers ****

    /// **** Functions ****
    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) public {
        Student memory student = Student({name: _name, attendance: _attendance, interests: _interests});
        students[msg.sender] = student;
        emit StudentCreated(msg.sender, _name);
    }

    function registerNewStudent(string memory _name, address _address) public studentDoesNotExist(_address) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        Student memory student = Student({name: _name, attendance: Attendance.Absent, interests: new string[](0)});
        students[_address] = student;
        emit StudentCreated(_address, _name);
    }

    function markAttendance(address _address, Attendance _attendance) public studentExists(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// Function to check if an interest exists for a student to avoid duplicates
    function interestExists(address _address, string memory _interest) internal view returns (bool) {
        string[] memory currentInterests = students[_address].interests;
        for (uint i = 0; i < currentInterests.length; i++) {
            if (keccak256(bytes(currentInterests[i])) == keccak256(bytes(_interest))) {
                return true;
            }
        }
        return false;
    }

    function addInterest(address _address, string memory _interest) public studentExists(_address) {
        require(bytes(_interest).length > 0, "Interest cannot be empty");
        require(students[_address].interests.length < 5, "Student already has 5 interests");
        require(!interestExists(_address, _interest), "Interest already exists");
        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    function removeInterest(address _address, string memory _interest) public {
        require(interestExists(_address, _interest), "Interest does not exist");
        string[] storage interests = students[_address].interests;
        uint indexToRemove;
        bool found = false;

        for (uint i = 0; i < interests.length; i++) {
            if (keccak256(bytes(interests[i])) == keccak256(bytes(_interest))) {
                indexToRemove = i;
                found = true;
                break;
            }
        }

        require(found, "Interest not found");

        // Move the last element to the position we want to remove
        interests[indexToRemove] = interests[interests.length - 1];
        // Remove the last element
        interests.pop();
    }

    /// Getter functions
    function getStudentName(address _address) public view studentExists(_address) returns (string memory) {
        return students[_address].name;
    }

    function getStudentInterests(address _address) public view studentExists(_address) returns (string[] memory) {
        return students[_address].interests;
    }

    function getStudentAttendance(address _address) public view studentExists(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    /// Function to transfer ownership of the contract
    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    /// **** End of Functions ****
}
