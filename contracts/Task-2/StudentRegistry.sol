// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentRegistry {
    
    enum Attendance { Present, Absent }

    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }

    mapping (address => Student) private students;

    address public owner;

    ///  Events for tracking contract actions
    event StudentCreated(address indexed studentAddress, string name);
    event AttendanceStatus(address indexed studentAddress, Attendance attendance);
    event InterestAdded(address indexed studentAddress, string interest);
    event InterestRemoved(address indexed studentAddress, string interest);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    ///  Modifier to restrict function access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    ///  Modifier to check if a student is already registered
    modifier studentExists(address _address) {
        require(bytes(students[_address].name).length > 0, "Student does not exist");
        _;
    }

    ///  Modifier to ensure a student is not already registered
    modifier duplicateStudent() {
        require(bytes(students[msg.sender].name).length == 0, "Student already registered");
        _;
    }

    ///  Initializes the contract by setting the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    ///  Registers a new student
function registerNewStudent(string memory _name) public duplicateStudent {
    require(bytes(_name).length > 0, "Please enter a name");


    emit StudentCreated(msg.sender, _name);
}

    ///  Updates the caller's attendance status
    function updateAttendance(Attendance _attendance) public studentExists(msg.sender) {
        students[msg.sender].attendance = _attendance;
        emit AttendanceStatus(msg.sender, _attendance);
    }

    ///  Adds an interest for the student
    function addInterest(string memory _interest) public studentExists(msg.sender) {
        require(bytes(_interest).length > 0, "Please enter an interest");
        require(students[msg.sender].interests.length < 5, "Maximum of 5 interests allowed");

        for (uint i = 0; i < students[msg.sender].interests.length; i++) {
            require(
                keccak256(abi.encodePacked(students[msg.sender].interests[i])) != keccak256(abi.encodePacked(_interest)),
                "Interest already exists"
            );
        }

        students[msg.sender].interests.push(_interest);
        emit InterestAdded(msg.sender, _interest);
    }

    ///  Removes an interest from the student's profile
    function removeInterest(string memory _interest) public studentExists(msg.sender) {
        string[] storage interests = students[msg.sender].interests;
        bool found = false;

        for (uint i = 0; i < interests.length; i++) {
            if (keccak256(abi.encodePacked(interests[i])) == keccak256(abi.encodePacked(_interest))) {
                interests[i] = interests[interests.length - 1]; // Swap with last element
                interests.pop(); // Remove last element
                found = true;
                break;
            }
        }

        require(found, "Interest not found");
        emit InterestRemoved(msg.sender, _interest);
    }

    ///  Returns the name of a student
    function getStudentName(address _address) public view studentExists(_address) returns (string memory) {
        return students[_address].name;
    }

    ///  Returns the attendance status of a student
    function getStudentAttendance(address _address) public view studentExists(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    ///  Returns the interests of a student
    function getStudentInterests(address _address) public view studentExists(_address) returns (string[] memory) {
        return students[_address].interests;
    }

    ///  Transfers contract ownership
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        require(_newOwner != owner, "Already the owner");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
