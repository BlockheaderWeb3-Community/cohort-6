// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry {
    // Attendance status.
    enum Attendance { Present, Absent }

    // Student data structure.
    struct Student {
        string name;
        Attendance attendance;
        string[] interests;
    }

    mapping(address => Student) public students;
    address public owner;

    event StudentCreated(address studentAddress, string name);
    event AttendanceStatus(address studentAddress, Attendance attendance);
    event InterestAdded(address studentAddress, string interest);
    event InterestRemoved(address studentAddress, string interest);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier studentExists(address studentAddress) {
        require(bytes(students[studentAddress].name).length != 0, "Student does not exist");
        _;
    }

    modifier studentDoesNotExist(address studentAddress) {
        require(bytes(students[studentAddress].name).length == 0, "Student already exists");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Register a student with full details.
    function registerStudent(
        string memory name,
        Attendance attendance,
        string[] memory interests
    ) public studentDoesNotExist(msg.sender) {
        require(bytes(name).length > 0, "Name cannot be empty");
        students[msg.sender] = Student(name, attendance, interests);
        emit StudentCreated(msg.sender, name);
    }

    // Register a student with a name and default attendance (Absent).
    function registerNewStudent(string memory name)
        public
        studentDoesNotExist(msg.sender)
    {
        require(bytes(name).length > 0, "Name cannot be empty");
        students[msg.sender] = Student(name, Attendance.Absent, new string[](0));
        emit StudentCreated(msg.sender, name);
    }

    // Update a student's attendance.
    function markAttendance(address studentAddress, Attendance attendance)
        public
        studentExists(studentAddress)
    {
        students[studentAddress].attendance = attendance;
        emit AttendanceStatus(studentAddress, attendance);
    }

    // Add an interest to a student's profile.
    function addInterest(address studentAddress, string memory interest)
        public
        studentExists(studentAddress)
    {
        require(bytes(interest).length > 0, "Interest cannot be empty");
        Student storage student = students[studentAddress];
        require(student.interests.length < 5, "Max interests reached");

        for (uint i = 0; i < student.interests.length; i++) {
            require(keccak256(bytes(student.interests[i])) != keccak256(bytes(interest)), "Duplicate interest");
        }
        student.interests.push(interest);
        emit InterestAdded(studentAddress, interest);
    }

    // Remove an interest from a student's profile.
    function removeInterest(address studentAddress, string memory interest)
        public
        studentExists(studentAddress)
    {
        Student storage student = students[studentAddress];
        uint length = student.interests.length;
        bool found = false;
        for (uint i = 0; i < length; i++) {
            if (keccak256(bytes(student.interests[i])) == keccak256(bytes(interest))) {
                student.interests[i] = student.interests[length - 1];
                student.interests.pop();
                found = true;
                emit InterestRemoved(studentAddress, interest);
                break;
            }
        }
        require(found, "Interest not found");
    }

    // Get the student's name.
    function getStudentName(address studentAddress)
        public
        view
        studentExists(studentAddress)
        returns (string memory)
    {
        return students[studentAddress].name;
    }

    // Get the student's attendance.
    function getStudentAttendance(address studentAddress)
        public
        view
        studentExists(studentAddress)
        returns (Attendance)
    {
        return students[studentAddress].attendance;
    }

    // Get the student's interests.
    function getStudentInterests(address studentAddress)
        public
        view
        studentExists(studentAddress)
        returns (string[] memory)
    {
        return students[studentAddress].interests;
    }

    // Transfer contract ownership.
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    // (Bonus) Update the caller's name.
    function updateStudentName(string memory newName)
        public
        studentExists(msg.sender)
    {
        require(bytes(newName).length > 0, "New name empty");
        students[msg.sender].name = newName;
        emit StudentCreated(msg.sender, newName);
    }
}
