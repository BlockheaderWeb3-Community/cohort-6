// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentRegistry {
    struct Student {
        string name;
        uint256 age;
        string course;
        string[] interests;
    }

    mapping(address => Student) private students;
    address[] private studentAddresses;
    address public owner;

    event StudentRegistered(address indexed studentAddress, string name, uint256 age, string course, string[] interests);
    event StudentUpdated(address indexed studentAddress, string name, uint256 age, string course, string[] interests);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerStudent(string memory _name, uint256 _age, string memory _course, string[] memory _interests) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_age > 0, "Age must be greater than zero");
        require(bytes(_course).length > 0, "Course cannot be empty");
        
        students[msg.sender] = Student(_name, _age, _course, _interests);
        studentAddresses.push(msg.sender);
        emit StudentRegistered(msg.sender, _name, _age, _course, _interests);
    }

    function updateStudent(string memory _name, uint256 _age, string memory _course, string[] memory _interests) public {
        require(bytes(students[msg.sender].name).length > 0, "Student not registered");
        
        students[msg.sender] = Student(_name, _age, _course, _interests);
        emit StudentUpdated(msg.sender, _name, _age, _course, _interests);
    }

    function getStudent(address _studentAddress) public view returns (string memory, uint256, string memory, string[] memory) {
        require(bytes(students[_studentAddress].name).length > 0, "Student not found");
        Student memory student = students[_studentAddress];
        return (student.name, student.age, student.course, student.interests);
    }

    function getAllStudents() public view onlyOwner returns (address[] memory) {
        return studentAddresses;
    }
}
