// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title PrimitiveDataTypes
/// @notice This contract demonstrates the use of primitive data types and operators in Solidity.
contract PrimitiveDataTypes {
    /// @notice Unsigned integer (uint) example.
    uint256 public myUint = 10;

    /// @notice Signed integer (int) example.
    int256 public myInt = -5;

    /// @notice Boolean (bool) example.
    bool public myBool = true;

    /// @notice Address example.
    address public myAddress = 0xFABB0ac9d68B0B445fB7357272Ff202C5651694a; // Example address

    /// @notice Bytes example (fixed-size byte array).
    bytes32 public myBytes = "Hello, world!";

    /// @notice String example.
    string public myString = "This is a string.";

    /// @notice Enum example.
    enum Status {
        Pending,
        Processing,
        Completed,
        Rejected
    }

    /// @notice State variable of the Status enum type.
    Status public myStatus = Status.Pending;

    /// @notice Function to demonstrate arithmetic operators.
    /// @param _a First unsigned integer.
    /// @param _b Second unsigned integer.
    /// @return The sum of _a and _b.
    function arithmetic(uint256 _a, uint256 _b) public pure returns (uint256) {
        uint256 sum = _a + _b; // Addition
        uint256 difference = _a - _b; // Subtraction
        uint256 product = _a * _b; // Multiplication
        uint256 quotient = _a / _b; // Division (integer division)
        uint256 remainder = _a % _b; // Modulo (remainder)

        //Note: Solidity does not have an exponentiation operator like ** in Python.  Use a library or loop for exponentiation.

        return sum; // Returns the sum. Other calculations are performed but not returned.
    }

    /// @notice Function to demonstrate comparison operators.
    /// @param _x First integer.
    /// @param _y Second integer.
    /// @return True if _x is greater than _y, false otherwise.
    function comparison(int256 _x, int256 _y) public pure returns (bool) {
        bool isEqual = _x == _y; // Equal to
        bool isNotEqual = _x != _y; // Not equal to
        bool isGreaterThan = _x > _y; // Greater than
        bool isLessThan = _x < _y; // Less than
        bool isGreaterThanOrEqual = _x >= _y; // Greater than or equal to
        bool isLessThanOrEqual = _x <= _y; // Less than or equal to

        return isGreaterThan; // Returns the result of the "greater than" comparison. Other comparisons are performed but not returned.
    }

    /// @notice Function to demonstrate logical operators.
    /// @param _p First boolean value.
    /// @param _q Second boolean value.
    /// @return True if both _p and _q are true, false otherwise.
    function logical(bool _p, bool _q) public pure returns (bool) {
        bool andResult = _p && _q; // Logical AND
        bool orResult = _p || _q; // Logical OR
        bool notResultP = !_p; // Logical NOT (applied to _p)
        bool notResultQ = !_q; // Logical NOT (applied to _q)

        return andResult; // Returns the result of the "AND" operation. Other logical operations are performed but not returned.
    }

    /// @notice Function to demonstrate bitwise operators.
    /// @param _a First unsigned integer.
    /// @param _b Second unsigned integer.
    /// @return The result of the bitwise AND operation.
    function bitwise(uint256 _a, uint256 _b) public pure returns (uint256) {
        uint256 andResult = _a & _b; // Bitwise AND
        uint256 orResult = _a | _b; // Bitwise OR
        uint256 xorResult = _a ^ _b; // Bitwise XOR
        uint256 notResult = ~_a; // Bitwise NOT (flips all bits)
        uint256 leftShift = _a << 1; // Left shift (multiplies by 2)
        uint256 rightShift = _a >> 1; // Right shift (divides by 2)

        return andResult; // Returns the result of the bitwise AND. Other bitwise operations are performed but not returned.
    }

    /// @notice Function to demonstrate assignment operators.
    /// @param _value Value to assign.
    function assignment(uint256 _value) public {
        myUint = _value; // Simple assignment
        myUint += 5; // Add and assign (myUint = myUint + 5)
        myUint -= 2; // Subtract and assign (myUint = myUint - 2)
        myUint *= 3; // Multiply and assign (myUint = myUint * 3)
        myUint /= 2; // Divide and assign (myUint = myUint / 2)
        myUint %= 7; // Modulo and assign (myUint = myUint % 7)
        myUint <<= 1; // Left shift and assign (myUint = myUint << 1)
        myUint >>= 1; // Right shift and assign (myUint = myUint >> 1)
    }

    /// @notice Function to change the status enum.
    /// @param _newStatus The new status to set.
    function setStatus(Status _newStatus) public {
        myStatus = _newStatus;
    }
}
