// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Student Registry Contract
/// @author Dinah Macaulay Egbezien 
/// @notice This contract allows students to register, manage attendance, and track interests.
/// @dev Implements ownership restrictions and data validation.

contract StudentRegistry {
    
    /// @notice Enum representing attendance status.
    enum Attendance {
        Present,  // Student is present
        Absent    // Student is absent
    }

    /// @notice Struct representing a student.
    /// @dev Each student has a name, attendance status, and an array of interests.
    struct Student {
        string name; 
        Attendance attendance; 
        string[] interests;
    }

    /// @notice Mapping to store student details by their address.
    mapping(address => Student) public students;

    /// @notice Address of the contract owner.
    address public owner;

    /// @notice Emitted when a new student is registered.
    /// @param _studentAddress Address of the registered student.
    /// @param _name Name of the student.
    event StudentCreated(address indexed _studentAddress, string _name);
    
    /// @notice Emitted when a student's attendance is updated.
    /// @param _studentAddress Address of the student.
    /// @param _attendance Updated attendance status.
    event AttendanceStatus(address indexed _studentAddress, Attendance _attendance);
    
    /// @notice Emitted when an interest is added to a student's profile.
    /// @param _studentAddress Address of the student.
    /// @param _interest Interest added.
    event InterestAdded(address indexed _studentAddress, string _interest);
    
    /// @notice Emitted when an interest is removed from a student's profile.
    /// @param _studentAddress Address of the student.
    /// @param _interest Interest removed.
    event InterestRemoved(address indexed _studentAddress, string _interest);

    /// @notice Restricts function execution to only the contract owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    /// @notice Ensures the student exists before performing an action.
    /// @param _address The address of the student.
    modifier studentExists(address _address) {
        require(bytes(students[_address].name).length > 0, "Student not registered");
        _;
    }

    /// @notice Ensures a student is not already registered.
    /// @param _name The name of the student.
    modifier studentDoesNotExist(string memory _name) {
        require(bytes(students[msg.sender].name).length == 0, "Student already registered");
        _;
    }

    /// @notice Sets the contract deployer as the initial owner.
    constructor() {
        owner = msg.sender;
    }

    /// @notice Registers a student with a given name, attendance status, and interests.
    /// @param _name Name of the student.
    /// @param _attendance Initial attendance status.
    /// @param _interests Array of initial interests.
    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) 
        public 
    {
        students[msg.sender].name = _name;
        students[msg.sender].attendance = _attendance;
        students[msg.sender].interests = _interests;

        emit StudentCreated(msg.sender, _name);
    }
    
    /// @notice Registers a new student with the default attendance set to Absent.
    /// @param _name Name of the student.
    function registerNewStudent(string memory _name) 
        public 
        studentDoesNotExist(_name) 
    {
        require(bytes(_name).length > 0, "Name cannot be empty");

        students[msg.sender].name = _name;
        students[msg.sender].attendance = Attendance.Absent;

        emit StudentCreated(msg.sender, _name);
    }

    /// @notice Marks a student's attendance.
    /// @param _address Address of the student.
    /// @param _attendance Attendance status to be recorded.
    function markAttendance(address _address, Attendance _attendance) 
        public 
        studentExists(_address) 
    {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// @notice Adds an interest to a student's profile.
    /// @dev Ensures interest is unique and does not exceed five interests.
    /// @param _address Address of the student.
    /// @param _interest Interest to be added.
    function addInterest(address _address, string memory _interest) 
        public 
        studentExists(_address) 
    {
        require(bytes(_interest).length > 0, "Interest cannot be empty");
        require(students[_address].interests.length < 5, "Only 5 interests are allowed");
        require(!interestExists(_address, _interest), "Interest already exists");

        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    /// @notice Checks if a student already has a specific interest.
    /// @dev Helper function to prevent duplicate interests.
    /// @param _address Address of the student.
    /// @param _interest Interest to check.
    /// @return bool True if the interest exists, false otherwise.
    function interestExists(address _address, string memory _interest) 
        internal 
        view 
        returns (bool) 
    {
        string[] memory interests = students[_address].interests;
        for (uint i = 0; i < interests.length; i++) {
            if (keccak256(bytes(interests[i])) == keccak256(bytes(_interest))) {
                return true;
            }
        }
        return false;
    }

    /// @notice Removes an interest from a student's profile.
    /// @dev Ensures the student exists and the interest is in their profile before removing.
    /// @param _address Address of the student.
    /// @param _interest Interest to remove.
    function removeInterest(address _address, string memory _interest) 
        public 
        studentExists(_address) 
    {
        uint indexToRemove = students[_address].interests.length;
        string[] storage interests = students[_address].interests;

        for (uint i = 0; i < interests.length; i++) {
            if (keccak256(bytes(interests[i])) == keccak256(bytes(_interest))) {
                indexToRemove = i;
                break;
            }
        }

        require(indexToRemove < interests.length, "Interest not found");

        interests[indexToRemove] = interests[interests.length - 1];
        interests.pop();

        emit InterestRemoved(_address, _interest);
    }

    /// @notice Gets a student's name.
    /// @param _address Address of the student.
    /// @return string Name of the student.
    function getStudentName(address _address) public view studentExists(_address) 
        returns (string memory) 
    {
        return students[_address].name;
    }

    /// @notice Gets a student's attendance status.
    /// @param _address Address of the student.
    /// @return Attendance The student's attendance status.
    function getStudentAttendance(address _address) public view studentExists(_address) 
        returns (Attendance) 
    {
        return students[_address].attendance;
    }

    /// @notice Gets a student's interests.
    /// @param _address Address of the student.
    /// @return string[] Array of interests.
    function getStudentInterests(address _address) public view studentExists(_address) 
        returns (string[] memory) 
    {
        return students[_address].interests;
    }

    /// @notice Transfers contract ownership to a new owner.
    /// @dev Restricted to only the current owner.
    /// @param _newOwner Address of the new owner.
    function transferOwnership(address _newOwner) 
        public 
        onlyOwner 
    {
        owner = _newOwner;
    }
}
