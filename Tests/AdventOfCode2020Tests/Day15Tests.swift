import AdventOfCode2020
import XCTest

final class Day15Tests: XCTestCase {
    func test_part1_test() {
        XCTAssertEqual(Day15.solvePartOne(from: testInput), 436)
        XCTAssertEqual(Day15.solvePartOne(from: "1,3,2"), 1)
        XCTAssertEqual(Day15.solvePartOne(from: "2,1,3"), 10)
        XCTAssertEqual(Day15.solvePartOne(from: "1,2,3"), 27)
        XCTAssertEqual(Day15.solvePartOne(from: "2,3,1"), 78)
        XCTAssertEqual(Day15.solvePartOne(from: "3,2,1"), 438)
        XCTAssertEqual(Day15.solvePartOne(from: "3,1,2"), 1836)
    }

    func test_part1_solution() {
        XCTAssertEqual(Day15.solvePartOne(from: solutionInput), 929)
    }

    func test_part2_test() {
        XCTAssertEqual(Day15.solvePartTwo(from: testInput), 175594)
        XCTAssertEqual(Day15.solvePartTwo(from: "1,3,2"), 2578)
        XCTAssertEqual(Day15.solvePartTwo(from: "2,1,3"), 3544142)
        XCTAssertEqual(Day15.solvePartTwo(from: "1,2,3"), 261214)
        XCTAssertEqual(Day15.solvePartTwo(from: "2,3,1"), 6895259)
        XCTAssertEqual(Day15.solvePartTwo(from: "3,2,1"), 18)
        XCTAssertEqual(Day15.solvePartTwo(from: "3,1,2"), 362)
    }

    func test_part2_solution() {
        XCTAssertEqual(Day15.solvePartTwo(from: solutionInput), 16671510)
    }
}

private let testInput = """
0,3,6
"""

private let solutionInput = """
16,1,0,18,12,14,19
"""
