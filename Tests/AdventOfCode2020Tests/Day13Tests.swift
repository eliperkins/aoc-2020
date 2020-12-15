// swiftlint:disable line_length

import AdventOfCode2020
import XCTest

final class Day13Tests: XCTestCase {
    func test_part1_test() {
        XCTAssertEqual(Day13.solvePartOne(from: testInput), 295)
    }

    func test_part1_solution() {
        XCTAssertEqual(Day13.solvePartOne(from: solutionInput), 8063)
    }

    func test_part2_test() {
        XCTAssertEqual(Day13.solvePartTwo(from: testInput), 1068781)
        XCTAssertEqual(Day13.solvePartTwo(from: "17,x,13,19"), 3417)
        XCTAssertEqual(Day13.solvePartTwo(from: "67,7,59,61"), 754018)
        XCTAssertEqual(Day13.solvePartTwo(from: "67,x,7,59,61"), 779210)
        XCTAssertEqual(Day13.solvePartTwo(from: "67,7,x,59,61"), 1261476)
        XCTAssertEqual(Day13.solvePartTwo(from: "1789,37,47,1889"), 1202161486)
    }

    func test_part2_solution() {
        XCTAssertEqual(Day13.solvePartTwo(from: solutionInput), 775230782877242)
    }
}

private let testInput = """
939
7,13,x,x,59,x,31,19
"""

private let solutionInput = """
1013728
23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,733,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,19,x,x,x,x,x,x,x,x,x,29,x,449,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37
"""
