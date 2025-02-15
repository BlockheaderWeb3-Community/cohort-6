// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title StudentRegistry
 * @dev Smart contract to manage student registrations, attendance, and interests.
 */
contract StudentRegistry {

    /// @notice Enum representing student attendance status.
    enum Attendance { Present, Absent }

    /// @notice Struct to store student details.
    struct Student {
        string name; 
        Attendance attendance; 
        string[] interests; 
    }

    /// @notice Mapping of student addresses to their details.
    mapping(address => Student) public students;
    /// @notice Owner of the contract.
    address public Admin;

    /// @notice Event emitted when a student is registered.
    event StudentCreated(address indexed _studentAddress, string _name);
    /// @notice Event emitted when a student's attendance is updated.
    event AttendanceStatus(address indexed _studentAddress, Attendance _attendance);
    /// @notice Event emitted when a student adds an interest.
    event InterestAdded(address indexed _studentAddress, string _interest);
    /// @notice Event emitted when a student removes an interest.
    event InterestRemoved(address indexed _studentAddress, string _interest);

    /// @dev Restricts function access to the contract Admin.
    modifier onlyAdmin() {
        require(msg.sender == Admin, "Only the Admin can call this function");
        _;
    }

    /// @dev Ensures a student exists before executing a function.
    modifier studentExists(address _address) {
        require(bytes(students[_address].name).length != 0, "Student does not exist");
        _;
    }

    /// @dev Ensures a student does not already exist before registration.
    modifier studentDoesNotExist(address _address) {
        require(bytes(students[_address].name).length == 0, "Student already exists");
        _;
    }

    /// @notice Sets the contract deployer as the Admin.
    constructor() {
        Admin = msg.sender;
    }

    /// @notice Registers a new student.
    /// @param _name Name of the student.
    /// @param _attendance Initial attendance status.
    /// @param _interests List of student interests.


    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) public studentDoesNotExist(msg.sender) {
        students[msg.sender] = Student(_name, _attendance, _interests);
        emit StudentCreated(msg.sender, _name);
    }

    /// @notice Registers a new student with only a name.
    /// @param _name Name of the student.


    function registerNewStudent(string memory _name) public studentDoesNotExist(msg.sender) {
        students[msg.sender] = Student(_name, Attendance.Absent, new string[](0));
        emit StudentCreated(msg.sender, _name);
    }

    /// @notice Updates the attendance of a student.
    /// @param _address Address of the student.
    /// @param _attendance New attendance status.
    function markAttendance(address _address, Attendance _attendance) public studentExists(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// @notice Adds a new interest for a student.
    /// @param _address Address of the student.
    /// @param _interest Interest to be added.
    function addInterest(address _address, string memory _interest) public studentExists(_address) {
        require(students[_address].interests.length < 5, "Cannot add more than 5 interests");
        
        for (uint i = 0; i < students[_address].interests.length; i++) {
            if (keccak256(abi.encodePacked(students[_address].interests[i])) == keccak256(abi.encodePacked(_interest))) {
                revert("Interest already exists");
            }
        }
        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    /// @notice Removes an interest from a student.
    /// @param _address Address of the student.
    /// @param _interest Interest to be removed.
    function removeInterest(address _address, string memory _interest) public studentExists(_address) {
        uint index = students[_address].interests.length;
        for (uint i = 0; i < students[_address].interests.length; i++) {
            if (keccak256(abi.encodePacked(students[_address].interests[i])) == keccak256(abi.encodePacked(_interest))) {
                index = i;
                break;
            }
        }
        require(index < students[_address].interests.length, "Interest does not exist");
        students[_address].interests[index] = students[_address].interests[students[_address].interests.length - 1];
        students[_address].interests.pop();
        emit InterestRemoved(_address, _interest);
    }

    /// @notice Gets the name of a student.
    /// @param _address Address of the student.
    /// @return Name of the student.

    function getStudentName(address _address) public view studentExists(_address) returns (string memory) {
        return students[_address].name;
    }

    /// @notice Gets the attendance status of a student.
    /// @param _address Address of the student.
    /// @return Attendance status.
    function getStudentAttendance(address _address) public view studentExists(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    /// @notice Gets the interests of a student.
    /// @param _address Address of the student.
    /// @return List of interests.
    function getStudentInterests(address _address) public view studentExists(_address) returns (string[] memory) {
        return students[_address].interests;
    }

    /// @notice Transfers contract ownership to a new Admin.
    /// @param _newOwner Address of the new Admin.
    function transferOwnership(address _newOwner) public onlyAdmin {
        require(_newOwner != address(0), "Invalid address");
        Admin = _newOwner;
    }

    /// @notice Updates a student's name.
    /// @param _newName New name of the student.
    
    function updateName(string memory _newName) public studentExists(msg.sender) {
        students[msg.sender].name = _newName;
    }
}
