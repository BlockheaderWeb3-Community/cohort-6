// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ControlFlow
/// @notice This contract demonstrates control flow structures in Solidity.
contract ControlFlow {
    /// @notice Example of an if-else statement.
    /// @param _x Integer input.
    /// @return True if _x is greater than 10, false otherwise.
    function ifElseStatement(int256 _x) public pure returns (bool) {
        if (_x > 10) {
            return true;
        } else {
            return false;
        }
    }

    /// @notice Example of a for loop. Calculates the sum of numbers from 0 to _n.
    /// @param _n Upper limit for the loop.
    /// @return The sum of numbers from 0 to _n.
    function forLoop(uint256 _n) public pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i <= _n; i++) {
            sum += i;
        }
        return sum;
    }

    /// @notice Example of a while loop. Calculates the sum of numbers from 0 to _n.
    /// @param _n Upper limit for the loop.
    /// @return The sum of numbers from 0 to _n.
    function whileLoop(uint256 _n) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        while (i <= _n) {
            sum += i;
            i++;
        }
        return sum;
    }

    /// @notice Example of a do-while loop. Calculates the sum of numbers from 0 to _n.
    /// @param _n Upper limit for the loop.
    /// @return The sum of numbers from 0 to _n.
    function doWhileLoop(uint256 _n) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        if (_n < 1) {
            return 0; // avoid infinite loop
        }
        do {
            sum += i;
            i++;
        } while (i <= _n);

        return sum;
    }

    /// @notice Example of a nested for loop. Creates a multiplication table up to _rows and _cols.
    /// @param _rows Number of rows in the table.
    /// @param _cols Number of columns in the table.
    /// @return A 2D array representing the multiplication table (simplified for demonstration).
    function nestedForLoop(uint256 _rows, uint256 _cols) public pure returns (uint256[2][2] memory) {
        // Simplified return for demonstration.  A dynamically sized array would be more appropriate for a real multiplication table.
        uint256[2][2] memory table; // Fixed size for demonstration.

        for (uint256 i = 1; i <= _rows; i++) {
            for (uint256 j = 1; j <= _cols; j++) {
                // In a real example, you would use a dynamic array or mapping to handle varying sizes.
                if (i <= 2 && j <= 2) {
                    // Limiting for demonstration purposes
                    table[i - 1][j - 1] = i * j;
                }
            }
        }
        return table;
    }

    /// @notice Demonstrates the use of `break` and `continue` keywords. Calculates the sum of even numbers from 1 to _limit, skipping odd numbers.
    /// @param _limit The upper limit of the range.
    /// @return The sum of even numbers within the specified limit.
    function breakContinue(uint256 _limit) public pure returns (uint256) {
        uint256 sum = 0;

        for (uint256 i = 1; i <= _limit; i++) {
            if (i % 2 != 0) {
                // If i is odd
                continue; // Skip to the next iteration
            }

            if (i > 10) {
                // Example break condition
                break; // Exit the loop entirely
            }

            sum += i;
        }
        return sum;
    }

    /// @notice Example of a ternary operator. Checks if a number is even or odd.
    /// @param _x The number to check.
    /// @return "Even" if _x is even, "Odd" otherwise.
    function ternaryOperator(int256 _x) public pure returns (string memory) {
        return _x % 2 == 0 ? "Even" : "Odd";
    }
}
