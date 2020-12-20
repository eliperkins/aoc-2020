import AdventOfCode2020
import XCTest

final class Day17Tests: XCTestCase {
    func test_part1_test() {
        XCTAssertEqual(Day17.solvePartOne(from: testInput), 112)
    }

    func test_part1_solution() {
        XCTAssertEqual(Day17.solvePartOne(from: solutionInput), 276)
    }

    func test_part2_test() {
        XCTAssertEqual(Day17.solvePartTwo(from: testInput), 848)
    }

    func test_part2_solution() {
        XCTAssertEqual(Day17.solvePartTwo(from: solutionInput), 2136)
    }
}

private let testInput = """
.#.
..#
###
"""

private let solutionInput = """
.#.####.
.#...##.
..###.##
#..#.#.#
#..#....
#.####..
##.##..#
#.#.#..#
"""
