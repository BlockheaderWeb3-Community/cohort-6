// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/**
 * @title StudentRegistry
 * @dev Manages student records, attendance, and interests.
 */
contract StudentRegistry {

    /// @notice Enum representing student attendance status.
    enum Attendance {
        Present,
        Absent
    }
    
    /// @notice Struct to store student details.
    struct studentDetails {
        string name;
        Attendance attendance;
        string[] interest;
    }

    /// @notice Address of the contract owner.
    address public owner;
    
    /// @notice Event emitted when ownership is transferred.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    /// @notice Sets the deployer as the initial owner.
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner); 
    }
    
    /// @notice Event emitted when a new student is registered.
    event createdStudent(string name, Attendance attendance, string[] interest);
    
    /// @notice Event emitted when a student's attendance status is updated.
    event AttendanceStatus(address studentAddress, Attendance attendanceStatus);
    
    /// @notice Event emitted when an interest is added.
    event InterestAdded(address studentAddress, string interest);
    
    /// @notice Event emitted when an interest is removed.
    event InterestRemoved(address studentAddress, string interest);
    
    /// @notice Mapping of student addresses to their details.
    mapping(address => studentDetails) public student;
    
    /// @notice Ensures only the contract owner can execute a function.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }
    
    /// @notice Ensures a student exists before executing a function.
    modifier studentExists(address _studentaddr) {
        require(bytes(student[_studentaddr].name).length != 0, "Student does not exist.");
        _;
    }

    /// @notice Ensures a student does not already exist before executing a function.
    modifier studentDoesNotExist(address _studentAddr) {
        require(bytes(student[_studentAddr].name).length == 0, "Student already exists.");
        _;
    }
    
    /// @notice Registers a new student with a default name and interests.
    function registerStudent() public studentDoesNotExist(msg.sender) {
        student[msg.sender].name = "Goodness";
        student[msg.sender].attendance = Attendance.Absent;        
        student[msg.sender].interest.push("football");
        student[msg.sender].interest.push("eating");
        student[msg.sender].interest.push("Youtube");
        student[msg.sender].interest.push("coding");
        student[msg.sender].interest.push("gaming");
        emit createdStudent(student[msg.sender].name, student[msg.sender].attendance, student[msg.sender].interest);
    }

    /// @notice Registers a student with a specified name.
    function registerNewStudent(string memory _name) public studentDoesNotExist(msg.sender) {
        student[msg.sender].name = _name;
        student[msg.sender].attendance = Attendance.Absent; 
        emit createdStudent(_name, Attendance.Absent, new string[](0));
    }
    
    /// @notice Updates a student's attendance status.
    function markAttendance(address _address, Attendance _attendance) public studentExists(_address) {
        student[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }
    
    /// @notice Adds an interest to a student's record.
    function addInterest(address _address, string memory _interest) public studentExists(_address) {
        require(bytes(_interest).length > 0, "Interest cannot be empty.");
        require(student[_address].interest.length < 5, "Cannot have more than 5 interests.");
        for (uint i = 0; i < student[_address].interest.length; i++) {
            require(
                keccak256(bytes(student[_address].interest[i])) != keccak256(bytes(_interest)),
                "Interest already exists."
            );
        }
        student[_address].interest.push(_interest);
        emit InterestAdded(_address, _interest);
    }
    
    /// @notice Removes an interest from a student's record.
    function removeInterest(address _address, string memory _interest) public studentExists(_address) {
        bool interestFound = false;
        uint indexToRemove;
        for (uint i = 0; i < student[_address].interest.length; i++) {
            if (keccak256(bytes(student[_address].interest[i])) == keccak256(bytes(_interest))) {
                interestFound = true;
                indexToRemove = i;
                break;
            }
        }
        require(interestFound, "Interest not found.");
        uint lastIndex = student[_address].interest.length - 1;
        if (indexToRemove != lastIndex) {
            student[_address].interest[indexToRemove] = student[_address].interest[lastIndex];
        }
        student[_address].interest.pop();
        emit InterestRemoved(_address, _interest);
    }
    
    /// @notice Retrieves a student's name.
    function getStudentName(address _address) public view studentExists(_address) returns (string memory) {
        return student[_address].name;
    }
    
    /// @notice Retrieves a student's attendance status.
    function getStudentAttendance(address _address) public view studentExists(_address) returns (Attendance) {
        return student[_address].attendance;
    }
    
    /// @notice Retrieves a student's interests.
    function getStudentInterests(address _address) public view studentExists(_address) returns (string[] memory) {
        return student[_address].interest;
    }
    
    /// @notice Transfers contract ownership to a new address.
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be the zero address.");
        address previousOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
}