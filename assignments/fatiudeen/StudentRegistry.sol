// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title Student Registry Contract
/// @notice A contract for managing student information, attendance, and interests
contract StudentRegistry {
    /// @notice Possible attendance statuses
    enum Attendance { Present, Absent }

    /// @notice Structure to store student information
    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }

    /// @notice Maps student addresses to their information
    mapping(address => Student) public students;
    
    /// @notice Contract owner address
    address public owner;

    /// @notice Emitted when a new student is registered
    event StudentCreated(address _studentAddress, string _name);
    /// @notice Emitted when attendance is updated
    event AttendanceStatus(address _studentAddress, Attendance _attendance);
    /// @notice Emitted when an interest is added
    event InterestAdded(address _studentAddress, string _interest);
    /// @notice Emitted when an interest is removed
    event InterestRemoved(address _studentAddress, string _interest);

    /// @notice Ensures only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /// @notice Ensures the student exists
    modifier studentExists(address _address) {
        require(bytes(students[_address].name).length > 0, "Student does not exist");
        _;
    }

    /// @notice Ensures the student does not exist
    modifier studentDoesNotExist(address _address) {
        require(bytes(students[_address].name).length == 0, "Student already exists");
        _;
    }

    /// @notice Sets the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    /// @notice Registers a new student with full information
    function registerStudent(
        string memory _name,
        Attendance _attendance,
        string[] memory _interests
    ) public studentDoesNotExist(msg.sender) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_interests.length <= 5, "Maximum 5 interests allowed");

        students[msg.sender] = Student({
            name: _name,
            attendance: _attendance,
            interests: _interests
        });

        emit StudentCreated(msg.sender, _name);
    }

    /// @notice Registers a new student with just a name
    function registerNewStudent(string memory _name) public studentDoesNotExist(msg.sender) {
        require(bytes(_name).length > 0, "Name cannot be empty");

        students[msg.sender] = Student({
            name: _name,
            attendance: Attendance.Absent,
            interests: new string[](0)
        });

        emit StudentCreated(msg.sender, _name);
    }

    /// @notice Updates a student's attendance
    function markAttendance(address _address, Attendance _attendance) 
        public 
        onlyOwner 
        studentExists(_address) 
    {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// @notice Adds an interest to a student's profile
    function addInterest(address _address, string memory _interest) 
        public 
        studentExists(_address) 
    {
        require(bytes(_interest).length > 0, "Interest cannot be empty");
        require(students[_address].interests.length < 5, "Maximum 5 interests allowed");
        
        // Check for duplicates
        for(uint i = 0; i < students[_address].interests.length; i++) {
            require(
                keccak256(bytes(students[_address].interests[i])) != keccak256(bytes(_interest)),
                "Interest already exists"
            );
        }

        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    /// @notice Removes an interest from a student's profile
    function removeInterest(address _address, string memory _interest) 
        public 
        studentExists(_address) 
    {
        string[] storage interests = students[_address].interests;
        bool found = false;
        uint indexToRemove;

        for(uint i = 0; i < interests.length; i++) {
            if(keccak256(bytes(interests[i])) == keccak256(bytes(_interest))) {
                indexToRemove = i;
                found = true;
                break;
            }
        }

        require(found, "Interest not found");

        // Move the last element to the position of the element to remove
        if(indexToRemove != interests.length - 1) {
            interests[indexToRemove] = interests[interests.length - 1];
        }
        interests.pop();

        emit InterestRemoved(_address, _interest);
    }

    /// @notice Gets a student's name
    function getStudentName(address _address) 
        public 
        view 
        studentExists(_address) 
        returns (string memory) 
    {
        return students[_address].name;
    }

    /// @notice Gets a student's attendance
    function getStudentAttendance(address _address) 
        public 
        view 
        studentExists(_address) 
        returns (Attendance) 
    {
        return students[_address].attendance;
    }

    /// @notice Gets a student's interests
    function getStudentInterests(address _address) 
        public 
        view 
        studentExists(_address) 
        returns (string[] memory) 
    {
        return students[_address].interests;
    }

    /// @notice Transfers ownership of the contract
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be zero address");
        owner = _newOwner;
    }
} 