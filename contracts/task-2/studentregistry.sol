// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentRegistry {
    struct Student {
        string name;
        Attendance attendance;
        string[5] interests;
    }
        // Enum for attendance status
    enum Attendance { Absent, Present }

    mapping(address => Student) public students;
    address public owner;



    // Event for student creation
    event StudentCreated(address _studentAddress, string _name);

        // Event for attendance status update
    event AttendanceStatus(address indexed studentAddress, Attendance attendance);

        // Event for adding interest
    event InterestAdded(address indexed studentAddress, string interest);

    // Event for interest removal
    event InterestRemoved(address indexed studentAddress, string interest);



        // Modifiers for student not registered
    modifier studentNotRegistered(address _studentAddress) {
        require(bytes(students[_studentAddress].name).length == 0, "Student already registered");
        _;
    }

        // Modifier to ensure student is registered
    modifier studentRegistered(address _studentAddress) {
        require(bytes(students[_studentAddress].name).length > 0, "Student not registered");
        _;
    }

        // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    

    // Set the deployer as the contract owner
    constructor() {
        owner = msg.sender;
    }



    // Function to register a new student with name, attendance, and interests
    function registerStudent(string memory _name, Attendance _attendance, string[] memory _interests) public studentNotRegistered(msg.sender) {
        require(bytes(_name).length > 0, "Student name cannot be empty");
        require(_interests.length <= 5, "Cannot add more than 5 interests");

        // Initialize interests array
        string[5] memory studentInterests;
        for (uint8 i = 0; i < _interests.length; i++) {
            studentInterests[i] = _interests[i];
        }

        // Create a new student
        students[msg.sender] = Student({
            name: _name,
            attendance: _attendance,
            interests: studentInterests
        });

        emit StudentCreated(msg.sender, _name);
    }


    // Function to register a new student
    function registerNewStudent(string memory _name) public studentNotRegistered(msg.sender) {
        require(bytes(_name).length > 0, "Name cannot be empty.");

        Student storage newStudent = students[msg.sender];
        newStudent.name = _name;
        newStudent.attendance = Attendance.Absent;

        emit StudentCreated(msg.sender, _name);
    }

    // Function to mark student attendance
    function markAttendance(address _address, Attendance _attendance) public studentRegistered(_address) {
        students[_address].attendance = _attendance;
        emit AttendanceStatus(_address, _attendance);
    }

    

    
    // Function to add an interest to a student’s profile
    function addInterest(address _studentAddress, string memory _interest) public studentRegistered(_studentAddress) {
        require(bytes(_interest).length > 0, "Interest cannot be empty");

        Student storage student = students[_studentAddress];

        // Check if the student already has the maximum number of interests (5)
        uint8 availableIndex = 5; 
        for (uint8 i = 0; i < 5; i++) {
            if (keccak256(bytes(student.interests[i])) == keccak256(bytes(_interest))) {
                revert("Interest already exists");
            }
            //checks for empty slot
            if (bytes(student.interests[i]).length == 0 && availableIndex == 5) {
                availableIndex = i; // Store the first empty index
            }
        }

        require(availableIndex < 5, "Student already has 5 interests");

        student.interests[availableIndex] = _interest;
        emit InterestAdded(_studentAddress, _interest);
    }

    //function to remove interest
    function removeInterest(address _studentAddress, string memory _interest) public studentRegistered(_studentAddress) {
    
    Student storage student = students[_studentAddress];

    // Find the interest in the array
    bool found = false;
    uint8 indexToRemove = 5;
    for (uint8 i = 0; i < 5; i++) {
        if (keccak256(bytes(student.interests[i])) == keccak256(bytes(_interest))) {
            found = true;
            indexToRemove = i;
            break;
        }
    }

    require(found, "Interest not found in profile");

    // Shift elements to remove the interest
    for (uint8 j = indexToRemove; j < 4; j++) {
        student.interests[j] = student.interests[j + 1];
    }
    student.interests[4] = ""; // Clear the last slot

    emit InterestRemoved(_studentAddress, _interest);
}


    // Getter for student's name
    function getStudentName(address _address) public view studentRegistered(_address) returns (string memory)  {
        return students[_address].name;
    }

    // Getter for student's attendance
    function getStuddentAttendance(address _address) public view studentRegistered(_address) returns (Attendance) {
        return students[_address].attendance;
    }

    // Getter for student's interests
    function getStudentInterests(address _address) public view studentRegistered(_address) returns (string[5] memory) {
        return students[_address].interests;
    }

        // Function to transfer ownership to a new address
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner address cannot be zero");
        owner = _newOwner;
    }

}
