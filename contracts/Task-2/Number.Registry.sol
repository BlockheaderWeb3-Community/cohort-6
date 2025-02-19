// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract StudentRegistry {
    // Enum for attendance status
    enum Attendance { Absent, Present }

    // Struct to represent a student
    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }

    // Mapping to store students by their address
    mapping(address => Student) public  students;

    // Event emitted when a student is registered
    event StudentCreated(address indexed studentAddress, string name);

    // Event emitted when attendance is marked
    event AttendanceStatus(address indexed studentAddress, Attendance attendance);

    // Event emitted when an interest is added
    event InterestAdded(address indexed studentAddress, string interest);

    // Event emitted when an interest is removed
    event InterestRemoved(address indexed studentAddress, string interest);

    // Modifier to ensure only registered students can perform actions
    modifier onlyRegisteredStudent(address _address) {
        require(bytes(students[_address].name).length > 0, "Student not registered");
        _;
    }

    // Modifier to ensure only the owner can perform certain actions
    address public  owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to register a new student
    function registerNewStudent(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(students[msg.sender].name).length == 0, "Student already registered");

        // Initialize the student struct
        students[msg.sender] = Student({
            name: _name,
            attendance: Attendance.Absent,
            interests: new string[](0)
        });

        emit StudentCreated(msg.sender, _name);
    }

    // Function to mark attendance
    function markAttendance(address _address, Attendance _attendance) public onlyRegisteredStudent(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    // Function to add an interest
    function addInterest(address _address, string memory _interest) public onlyRegisteredStudent(_address) {
        require(bytes(_interest).length > 0, "Interest cannot be empty");
        require(students[_address].interests.length <= 5, "Maximum of 5 interests allowed");

        // Check for duplicate interests
        for (uint i = 0; i < students[_address].interests.length; i++) {
            require(
                keccak256(bytes(students[_address].interests[i])) != keccak256(bytes(_interest)),
                "Interest already exists"
            );
        }

        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    // Function to remove an interest
    function removeInterest(address _address, string memory _interest) public onlyRegisteredStudent(_address) {
        string[] storage interests = students[_address].interests;
        bool interestFound = false;

        for (uint i = 0; i < interests.length; i++) {
            if (keccak256(bytes(interests[i])) == keccak256(bytes(_interest))) {
                // Swap with the last element and pop
                interests[i] = interests[interests.length - 1];
                interests.pop();
                interestFound = true;
                emit InterestRemoved(_address, _interest);
                break;
            }
        }

        require(interestFound, "Interest not found");
    }

    // Getter functions
    function getStudentName(address _address) public view onlyRegisteredStudent(_address) returns (string memory) {
        return students[_address].name;
    }

    function getStudentAttendance(address _address) public view onlyRegisteredStudent(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    function getStudentInterests(address _address) public view onlyRegisteredStudent(_address) returns (string[] memory) {
        return students[_address].interests;
    }

    // Ownership management
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

    // Bonus: Allow a student to update their name
    function updateStudentName(string memory _newName) public onlyRegisteredStudent(msg.sender) {
        require(bytes(_newName).length > 0, "Name cannot be empty");
        students[msg.sender].name = _newName;
    }
}