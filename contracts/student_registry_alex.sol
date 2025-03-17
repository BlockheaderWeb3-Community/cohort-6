// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

/// @title StudentRegistry
/// @dev A contract to manage student registration, attendance, and interests.
contract StudentRegister {
    /// @dev Enum to represent student attendance status.
    enum Attendance {
        Absent,
        Present
    }

    /// @dev Struct to represent a student.
    struct Student {
        string Name; // Name of the student
        Attendance attendance; // Attendance status of the student
        string[] interest; // List of interests of the student
    }

    /// @dev Address of the contract owner.
    address public owner;

    /// @dev Mapping to store student data by their address.
    mapping(address => Student) public students;

    /// @dev Event emitted when a new student is registered.
    event StudentCreated(address indexed _studentAddress, string _name);

    /// @dev Event emitted when a student's attendance status is updated.
    event AttendanceStatus(address indexed _studentAddress, Attendance _attendance);

    /// @dev Event emitted when a new interest is added to a student's profile.
    event InterestAdded(address indexed _studentAddress, string _interest);

    /// @dev Event emitted when an interest is removed from a student's profile.
    event InterestRemoved(address indexed _studentAddress, string _interest);

    /// @dev Modifier to restrict access to the contract owner.
    modifier OnlyOwner() {
        require(msg.sender == owner, "Owner only function");
        _;
    }

    /// @dev Modifier to ensure a student with the given address exists.
    modifier studentExists(address _studentaddr) {
        require(bytes(students[_studentaddr].Name).length != 0, "The specified student does not exist.");
        _;
    }

    /// @dev Modifier to ensure a student with the given address does not exist.
    modifier studentDoesNotExist(address _studentAddr) {
        require(bytes(students[_studentAddr].Name).length == 0, "The specified student already exists.");
        _;
    }

    /// @dev Constructor to set the contract owner.
    constructor() {
        owner = msg.sender;
    }

    /// @dev Registers a new student with a name, attendance status, and interests.
    /// @param _name The name of the student.
    /// @param _attendance The attendance status of the student.
    /// @param _interests The list of interests of the student.
    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) public {
        students[msg.sender].Name = _name;
        students[msg.sender].attendance = _attendance;
        students[msg.sender].interest = _interests;

        emit StudentCreated(msg.sender, _name);
    }

    /// @dev Registers a new student with a default attendance status (Absent) and no interests.
    /// @param _name The name of the student.
    function registerNewStudent(string memory _name) public studentDoesNotExist(msg.sender) {
        require(bytes(_name).length > 0, "The provided name is empty.");
        students[msg.sender] = Student({Name: _name, attendance: Attendance.Absent, interest: new string[](0)});

        emit StudentCreated(msg.sender, _name);
    }

    /// @dev Marks the attendance of a student.
    /// @param _address The address of the student.
    /// @param _attendance The attendance status to set (Absent or Present).
    function markAttendance(address _address, Attendance _attendance) public studentExists(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    /// @dev Adds an interest to a student's profile.
    /// @param _address The address of the student.
    /// @param _interest The interest to add.
    function addInterests(address _address, string memory _interest) public studentExists(_address) {
        require(bytes(_interest).length > 0, "The provided interest is empty.");
        require(bytes(_interest).length <= 5, "Maximum of 5 interests can be added.");

        for (uint256 i = 0; i < students[_address].interest.length; i++) {
            require(
                keccak256(bytes(students[_address].interest[i])) != keccak256(bytes(_interest)),
                "Interest already exists."
            );
        }
        students[_address].interest.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    /// @dev Removes an interest from a student's profile.
    /// @param _addr The address of the student.
    /// @param _interest The interest to remove.
    function removeInterest(address _addr, string memory _interest) public studentExists(_addr) {
        require(bytes(students[_addr].Name).length >= 0, "Interest cannot be empty.");
        bool indexFound = false;
        uint indexToRemove;
        for (uint i = 0; i < students[_addr].interest.length; i++) {
            if (keccak256(bytes(students[_addr].interest[i])) == keccak256(bytes(_interest))) {
                indexFound = true;
                indexToRemove = i;
                break;
            }
        }
        require(indexFound, "The provided interest does not exist.");

        // Move the last element into the place of the element to remove
        students[_addr].interest[indexToRemove] = students[_addr].interest[students[_addr].interest.length - 1];

        // Remove the last element
        students[_addr].interest.pop();

        emit InterestRemoved(_addr, _interest);
    }

    /// @dev Retrieves the name of a student.
    /// @param _addr The address of the student.
    /// @return The name of the student.
    function getStudentName(address _addr) public view studentExists(_addr) returns (string memory) {
        return students[_addr].Name;
    }

    /// @dev Retrieves the attendance status of a student.
    /// @param _address The address of the student.
    /// @return The attendance status of the student.
    function getStudentAttendance(address _address) public view studentExists(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    /// @dev Retrieves the list of interests of a student.
    /// @param _address The address of the student.
    /// @return The list of interests of the student.
    function getStudentInterests(address _address) public view studentExists(_address) returns (string[] memory) {
        return students[_address].interest;
    }

    /// @dev Transfers ownership of the contract to a new address.
    /// @param _newOwner The address of the new owner.
    function transferOwnership(address _newOwner) public OnlyOwner {
        owner = _newOwner;
    }
}
