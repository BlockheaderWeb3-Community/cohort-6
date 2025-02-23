// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/// @title A Student Registry Contract
/// @author FRANKHOOD
/// @notice This contract registers students with their names, attendance and interests
contract StudentRegistry{
    enum Attendance {
        present, 
        absent
    }

    struct Student { 
        string name; 
        Attendance attendance; 
        string[] interests; 
        }

    mapping(address => Student) public students;
    address public owner;


/// @param _studentAddress the address of the students that are registered
/// @param _name the name of the students
    event StudentCreated(address _studentAddress, string _name);

/// @param _attendance the attendance of the student address, whether presentor absent 
    event AttendanceStatus(address _studentAddress, Attendance _attendance);

/// @param _interest the interests of the students
    event InterestAdded(address _studentAddress, string _interest);
    event InterestRemoved(address _studentAddress, string _interest);
    
/// @param _newName is the new name of the student after changing
    event NameUpdated(address _studentAddress, string _newName);


/// @notice this modifier requires that only the owner of the contract can perform any function where it is passed
    modifier onlyOwner {
        require(owner == msg.sender,"you are not the owner");
        _;
    }

/// @notice this modifier requires that the student is registered in any function where it is passed
    modifier studentExists(address _address, string memory _name){
        require (bytes(students[_address].name).length > 0, "student is not registered");
        _;
    }

/// @notice this modifier requires that the student is not registered in any function where it is passed
    modifier studentDoesNotExist(address _address, string memory _name){
        require (bytes(students[_address].name).length <= 0, "student is already registered");
        _;
    }

/// @notice this function registers students
/// @param _address this is the address of the student
/// @param _name the name of the student
/// @param _attendance the attendance of the student
/// @param _interests the interests of the student
    function registerStudent(address _address, string memory _name, Attendance _attendance, string[] memory _interests) public {
        students[_address].name = _name;
        students[_address].attendance = _attendance;
        students[_address].interests = _interests;

        emit StudentCreated(_address, _name);
    }

/// @notice this function registers a new student
/// @dev default Attendance bool is set as false
    function registerNewStudent(string memory _name, address _address) public studentDoesNotExist(_address, _name) {
        students[_address].name = _name;
        students[_address].attendance = Attendance.absent;

        emit StudentCreated(_address, _name);
    }

/// @notice this function marks the attendance of the student 
    function markAttendance(address _address, string memory _name, Attendance _attendance) public studentExists(_address, _name){
        students[_address].attendance=_attendance;

        emit AttendanceStatus(_address, _attendance);
    }

/// @notice this function adds an interest to the student interests
/// @notice requires the interest to be less than 5 but not empty while ensuring not interest is repeated
    function addInterest(address _address, string memory _interest, string memory _name) public studentExists(_address, _name){
        require(bytes(_interest).length > 0, "Interest cannot be empty");  
        require(students[_address].interests.length < 5, "Student already has 5 interests");

        string[] storage interests =students[_address].interests;

        for (uint i = 0; 
        i < interests.length;
         i++){
            require(keccak256(abi.encodePacked(interests[i])) != keccak256(abi.encodePacked(_interest)));// ensuring no interest is repeated
         }

        students[_address].interests.push(_interest);

        emit InterestAdded(_address, _interest);
    }

/// @notice this function removes an interest from the arrray
/// @dev to efficiently remove an array, we swap the interest we intend to remove with the last interest of the array
    function removeInterest(address _address, string memory _name, string memory _interest) public studentExists(_address, _name){
        string[] storage interests = students[_address].interests; 
    uint length = interests.length;
    
    require(length > 0, "No interests to remove");

    bool found = false;
    uint index;
    for (uint i = 0; i < length; i++) {
        if (keccak256(abi.encodePacked(interests[i])) == keccak256(abi.encodePacked(_interest))) {
            found = true;
            index = i;
            break;
        }
    }

    require(found, "Interest not found");

    interests[index] = interests[length - 1];// Replaces the found element with the last element
    interests.pop(); // Remove the last element

    emit InterestRemoved(_address, _interest);
    }

/// @notice this function returns the student's name
    function getStudentName(address _address, string memory _name) public view studentExists(_address, _name) returns (string memory) {
        
        return students[_address].name;
    }
    
/// @notice this function returns the student's attendance
    function getStudentAttendance(address _address, string memory _name) public view studentExists(_address, _name) returns (Attendance) {
        
        return students[_address].attendance;
    }

/// @notice this function returns the student's interests
    function getStudentInterests(address _address, string memory _name) public view studentExists(_address, _name) returns (string[] memory interests) {
        
        return students[_address].interests;
    }

    constructor(){
        owner == msg.sender;
    }

/// @notice this function transfers ownership toa new owner
    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

/// @notice this function updates the student's name to a new name
    function updateName(address _address, string memory _name, string memory _newName) public studentExists(_address, _name) {
        require(bytes(_newName).length > 0, "Name cannot be empty");

        students[msg.sender].name = _newName;

        emit NameUpdated(_address, _newName);
    }
}