import Algorithms

enum Square: String {
    case tree = "#"
    case empty = "."
}

public enum Day3 {
    static func parseInput(_ input: String) -> [[Square]] {
        input.split(whereSeparator: \.isNewline)
            .map { $0.compactMap { Square(rawValue: String($0)) } }
    }

    static func countTrees(in input: String, slopeRight: Int, slopeDown: Int = 1) -> Int {
        parseInput(input)
            .enumerated()
            .reduce((0, (0, 0)), { acc, next in
                let (yIndex, line) = next
                let (count, (x, y)) = acc
                let nextPoint = (x.advanced(by: slopeRight), y.advanced(by: slopeDown))

                // lol hack
                if yIndex % slopeDown != 0 {
                    return (count, (x, y.advanced(by: slopeDown)))
                }

                // repeating indicies
                var nextIndex = x
                if !line.indices.contains(nextIndex) {
                    nextIndex = nextIndex % line.endIndex
                }

                if line[nextIndex] == .tree {
                    return (count + 1, nextPoint)
                }

                return (count, nextPoint)
            })
            .0
    }

    public static func solvePartOne(from input: String) -> Int {
        countTrees(in: input, slopeRight: 3)
    }

    public static func solvePartTwo(from input: String) -> Int {
        [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
            .reduce(into: 1) { acc, next in
                acc *= countTrees(in: input, slopeRight: next.0, slopeDown: next.1)
            }
    }
}
