// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry{

    //struct data structure
    struct Student{
        string name;
        Attendance attendance;
        string[5] interests;
    }

    //enum data structure
    enum Attendance{
        Absent, 
        Present
    }

    //state variables
    mapping(address => Student) public students;
    address public owner;

    //events declaration
    event StudentCreated(address _studentAddress, string _name);
    event AttendanceStatus(address _studentAddress, Attendance _attendance);
    event InterestAdded(address _studentAddress, string _interest);
    event InterestRemoved(address _studentAddress, string _interest);

    //constructor
    constructor(){
        //set transaction sender as owner
        owner = msg.sender;
    }

   
    //modifier: to ensure the deployer is the owner
    modifier onlyOwner(){
        require(owner == msg.sender, "Not the contract owner");
        _;
    }

    //to check existence of students 
    modifier studentExists(address _address){
        uint len = keccak256(abi.encodePacked(students[_address].name)).length;
        require(len != 0, "student doesn't exists");
        _;
    }
    //checks to see if a student doesn't exist
    modifier studentDoesNotExist(address _address){
        uint len = keccak256(abi.encodePacked(students[_address].name)).length;
        require(len == 0, "student exists");
        _;
    }

    

    //functions

    //registerStudent: to add a student to the mapping and to structs
    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) public{
        students[msg.sender].name = _name;
        students[msg.sender].attendance = _attendance;
        students[msg.sender].interests = _interests;

        emit StudentCreated(msg.sender, _name);
    }

    //registerNewStudent: adding a new student with attendance: Absent
    function registerNewStudent(string memory _name) public studentDoesNotExist(msg.sender){
        require(keccak256(abi.encodePacked(_name)).length > 0, "student name cannot be blank");
        students[msg.sender].name = _name;
        students[msg.sender].attendance = Attendance.Absent;
        
        emit StudentCreated(msg.sender, _name);
    }

    //markAttendance: records a student's attendance
    function markAttendance(address _address, Attendance _attendace)public studentExists(_address){
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    //addInterests(): to add interests of a student
    function addInterests(address _address, string memory _interest)public studentExists(_address){
        uint count = students[_address].interests.length;
        require(keccak256(abi.encodePacked(_interest)) > 0, "Interest param cannot be blank");
        require(count < 5, "Student already has 5 interests");
        for(uint i = 0; i < count; i++){
            require(students[_address].interests[i] != _interests, "student interest already exists, Hence cannot add");
        }
        students[_address].interests.push(_interest);
        emit InterestAdded(_address, _interest);
    }

    //removeInterest(): removes a studdent's interest
    function removeInterest(address _address, string memory _interest) public studentExists(_address) {
        require(keccak256(abi.encodePacked(_interest)) > 0, "Interest param cannot be blank");
        uint index;
        uint len = students[_addr].interest.length;
        bool exists = false;
        
        for (uint i = 0; i < len; i++) {
            if (keccak256(abi.encodePacked(students[_address].interest[i])) == keccak256(abi.encodePacked(_interest))) {
                exists = true;
                index = i;
                break;
            }
        }
        require(exists, "doesn't exist");
        
         // Remove the interest value
        delete students[_address].interest[index];

        emit InterestRemoved(_address, _interest);
    }


     //transfer ownership function
    function transferOwnership(address _newOwner) public onlyOwner(){
        owner = _newOwner;
    }

    //returns a student name
    function getStudentName(address _address) public view studentExists(_address) returns(string memory _name){
        _name = students[_address].name;
    }

    //returns a student attendance
    function getStudentAttendance(address _address) public view studentExists(_address) returns(Attendance _att){
        _att = students[_address].attendance;
    }
    //returns a student name
    function getStudentInterests(address _address) public view studentExists(_address) returns(string[] memory _interests){
        _interests = students[_address].interest;   
    }

}