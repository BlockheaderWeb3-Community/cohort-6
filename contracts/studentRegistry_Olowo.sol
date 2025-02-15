// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/// @title A student Registry contract
/// @author Darey Olowo
/// @notice this contract allows for student registration and management
/// @dev Implements basic student functionalities such as registration, attendance tracking, and interest management
/// @custom:experimental This is an experimental contract.

contract Students {
    /// @notice Enum representing student attendance status
    enum Attendance {
        present,
        absent
    }
    /// @notice Struct to store student details
    struct Student {
        string name;
        Attendance attendance;
        string[] interest;
    }
    /// @notice Address of the contract owner
    address public owner;

    /// @notice Event emitted when a new student is registered
    event StudentCreated(string name, uint attendance, string[] interest);
    /// @notice Event emitted when a new interest is added to a student's profile
    event InterestAdded(address student, string interest);
    /// @notice Event emitted when an interest is removed from a student's profile
    event InterestRemoved(address student, string interest);
    /// @notice Event emitted when a student's attendance status is updated
    event AttendanceStatus(address indexed student, Attendance attendance);
    /// @notice Event emitted when contract ownership is transferred
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @dev Mapping to store student details based on address
    mapping(address => Student) public studentMap;
    /// @notice Ensures that only the contract owner can execute the function
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }
    /// @notice Ensures that the sender is not already registered
    modifier notRegistered() {
        require(bytes(studentMap[msg.sender].name).length == 0, "Address already registered!");
        _;
    }
    /// @notice Ensures that the provided address is registered
    modifier onlyRegistered(address _address) {
        require(bytes(studentMap[_address].name).length > 0, "Student is not registered!");
        _;
    }

    /// @notice Contract constructor setting the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    /// @notice Registers the sender as a student with predefined details
    function registerStudent() public notRegistered {
        studentMap[msg.sender].name = "Darey";
        studentMap[msg.sender].attendance = Attendance.absent;
        studentMap[msg.sender].interest.push("game");
        studentMap[msg.sender].interest.push("football");
        studentMap[msg.sender].interest.push("fifa");
        studentMap[msg.sender].interest.push("reading");
        studentMap[msg.sender].interest.push("coding");

        emit StudentCreated(
            studentMap[msg.sender].name,
            uint(studentMap[msg.sender].attendance),
            studentMap[msg.sender].interest
        );
    }

    /// @notice Registers a new student with custom details
    /// @param _name Name of the student
    /// @param _interest1 First interest
    /// @param _interest2 Second interest
    /// @param _interest3 Third interest
    /// @param _interest4 Fourth interest
    /// @param _interest5 Fifth interest

    function registerNewStudent(
        string memory _name,
        string memory _interest1,
        string memory _interest2,
        string memory _interest3,
        string memory _interest4,
        string memory _interest5
    ) public notRegistered {
        require(bytes(_name).length > 0, "Name cannot be empty");

        studentMap[msg.sender].name = _name;
        studentMap[msg.sender].attendance = Attendance.absent;

        if (bytes(_interest1).length > 0) studentMap[msg.sender].interest.push(_interest1);
        if (bytes(_interest2).length > 0) studentMap[msg.sender].interest.push(_interest2);
        if (bytes(_interest3).length > 0) studentMap[msg.sender].interest.push(_interest3);
        if (bytes(_interest4).length > 0) studentMap[msg.sender].interest.push(_interest4);
        if (bytes(_interest5).length > 0) studentMap[msg.sender].interest.push(_interest5);

        emit StudentCreated(
            studentMap[msg.sender].name,
            uint(studentMap[msg.sender].attendance),
            studentMap[msg.sender].interest
        );
    }

    /// @notice Updates the attendance status of a student
    /// @param _address Student address
    /// @param _attendance Attendance status (present/absent)
    function markAttendance(address _address, Attendance _attendance) public onlyRegistered(_address) {
        studentMap[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// @notice Adds a new interest to a student's profile
    /// @param _address Student address
    /// @param _interest Interest to add
    function addInterest(address _address, string memory _interest) public onlyRegistered(_address) {
        require(bytes(_interest).length < 0, "Interest cannot be empty.");

        for (uint i = 0; i < studentMap[_address].interest.length; i++) {
            // check if the interest is there first b4 adding it
            require(
                keccak256(bytes(studentMap[_address].interest[i])) != keccak256(bytes(_interest)),
                "Interest already exists."
            );
        }

        studentMap[_address].interest.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    /// @notice Removes an interest from a student's profile
    /// @param _address Student address
    /// @param _interest Interest to remove
    function removeInterest(address _address, string memory _interest) public onlyRegistered(_address) {
        require(bytes(_interest).length > 0, "Interest cannot be empty.");

        uint length = studentMap[_address].interest.length;
        bool found = false;

        for (uint i = 0; i < length; i++) {
            if (keccak256(bytes(studentMap[_address].interest[i])) == keccak256(bytes(_interest))) {
                found = true;

                for (uint j = i; j < length - 1; j++) {
                    // if its found the interest it will shift all element left taking the found one to the end to enable the pop function
                    studentMap[_address].interest[j] = studentMap[_address].interest[j + 1];
                }

                studentMap[_address].interest.pop();
                emit InterestRemoved(_address, _interest);
                break;
            }
        }

        require(found, "Interest not found.");
    }

    /// @notice Transfers contract ownership to a new address
    /// @param _newOwner Address of the new owner
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    /// @notice Gets the name of a student
    /// @param _address Student address
    function getStudentName(address _address) public view onlyRegistered(_address) returns (string memory) {
        return studentMap[_address].name;
    }

    /// @notice Gets the attendance status of a student
    /// @param _address Student address
    function getStudentAttendance(address _address) public view onlyRegistered(_address) returns (Attendance) {
        return studentMap[_address].attendance;
    }

    /// @notice Gets the list of interests of a student
    /// @param _address Student address
    function getStudentInterests(address _address) public view onlyRegistered(_address) returns (string[] memory) {
        return studentMap[_address].interest;
    }
}
