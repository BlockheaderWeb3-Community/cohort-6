// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StudentRegistry {
    struct Student {
        string name;
        Attendance attendance;
        string[5] interests;
    }

    enum Attendance {
        Absent,
        Present
    }

    mapping(address => Student) public students;
    address public owner;

    event StudentCreated(address _studentAddress, string _name);

    event AttendanceStatus(address indexed studentAddress, Attendance attendance);

    event InterestAdded(address indexed studentAddress, string interest);

    event InterestRemoved(address indexed studentAddress, string interest);

    modifier studentNotRegistered(address _studentAddress) {
        require(bytes(students[_studentAddress].name).length == 0, "Student already registered");
        _;
    }

    modifier studentRegistered(address _studentAddress) {
        require(bytes(students[_studentAddress].name).length > 0, "Student not registered");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerStudent(
        string memory _name,
        Attendance _attendance,
        string[] memory _interests
    ) public studentNotRegistered(msg.sender) {
        require(bytes(_name).length > 0, "Student name cannot be empty");
        require(_interests.length <= 5, "Cannot add more than 5 interests");

        string[5] memory studentInterests;
        for (uint8 i = 0; i < _interests.length; i++) {
            studentInterests[i] = _interests[i];
        }

        students[msg.sender] = Student({name: _name, attendance: _attendance, interests: studentInterests});

        emit StudentCreated(msg.sender, _name);
    }

    function registerNewStudent(string memory _name) public studentNotRegistered(msg.sender) {
        require(bytes(_name).length > 0, "Name cannot be empty.");

        Student storage newStudent = students[msg.sender];
        newStudent.name = _name;
        newStudent.attendance = Attendance.Absent;

        emit StudentCreated(msg.sender, _name);
    }

    function markAttendance(address _address, Attendance _attendance) public studentRegistered(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    function addInterest(address _studentAddress, string memory _interest) public studentRegistered(_studentAddress) {
        require(bytes(_interest).length > 0, "Interest cannot be empty");

        Student storage student = students[_studentAddress];

        uint8 availableIndex = 5;
        for (uint8 i = 0; i < 5; i++) {
            if (keccak256(bytes(student.interests[i])) == keccak256(bytes(_interest))) {
                revert("Interest already exists");
            }
            if (bytes(student.interests[i]).length == 0 && availableIndex == 5) {
                availableIndex = i; // Store the first empty index
            }
        }

        require(availableIndex < 5, "Student already has 5 interests");

        student.interests[availableIndex] = _interest;
        emit InterestAdded(_studentAddress, _interest);
    }

    function removeInterest(
        address _studentAddress,
        string memory _interest
    ) public studentRegistered(_studentAddress) {
        Student storage student = students[_studentAddress];

        bool found = false;
        uint8 indexToRemove = 5;
        for (uint8 i = 0; i < 5; i++) {
            if (keccak256(bytes(student.interests[i])) == keccak256(bytes(_interest))) {
                found = true;
                indexToRemove = i;
                break;
            }
        }

        require(found, "Interest not found in profile");

        for (uint8 j = indexToRemove; j < 4; j++) {
            student.interests[j] = student.interests[j + 1];
        }
        student.interests[4] = "";

        emit InterestRemoved(_studentAddress, _interest);
    }

    function getStudentName(address _address) public view studentRegistered(_address) returns (string memory) {
        return students[_address].name;
    }

    function getStuddentAttendance(address _address) public view studentRegistered(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    function getStudentInterests(address _address) public view studentRegistered(_address) returns (string[5] memory) {
        return students[_address].interests;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner address cannot be zero");
        owner = _newOwner;
    }
}
