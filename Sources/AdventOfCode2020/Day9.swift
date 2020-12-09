import Algorithms

public enum Day9 {
    struct Preamble {
        let values: [Int]
        let length: Int

        private let validNextNumbers: Set<Int>

        init(values: [Int], length: Int? = nil) {
            self.values = values
            let resolvedLength = length ?? values.count
            self.length = resolvedLength
            self.validNextNumbers = Set(values.suffix(resolvedLength).permutations(ofCount: 2).map { $0.reduce(0, +) })
        }

        func isValidNextNumber(_ number: Int) -> Bool {
            return validNextNumbers.contains(number)
        }

        enum Error: Swift.Error {
            case invalidValue
        }

        func appending(_ value: Int) throws -> Preamble {
            guard isValidNextNumber(value) else { throw Preamble.Error.invalidValue }
            return Preamble(values: values + [value], length: self.length)
        }
    }

    static func parse(input: String) -> [Int] {
        input.lines.compactMap(Int.init)
    }

    static func findFirstInvalidValue(from values: [Int], preambleLength: Int) -> Int {
        let startingValues = Array(values.prefix(preambleLength))

        var currentPreamble = Preamble(values: startingValues)
        for value in values.dropFirst(preambleLength) {
            do {
                currentPreamble = try currentPreamble.appending(value)
            } catch {
                return value
            }
        }

        fatalError("valid sequence! aborting")
    }

    public static func solvePartOne(from input: String, preambleLength: Int) -> Int {
        findFirstInvalidValue(from: parse(input: input), preambleLength: preambleLength)
    }

    public static func solvePartTwo(from input: String, preambleLength: Int) -> Int {
        let values = parse(input: input)
        let firstInvalid = findFirstInvalidValue(from: values, preambleLength: preambleLength)

        for length in 2...values.count {
            for startingIndex in values.startIndex...values.endIndex.advanced(by: -length) {
                let endingIndex = startingIndex.advanced(by: length - 1)
                let slice = values[startingIndex...endingIndex]
                if slice.reduce(0, +) == firstInvalid {
                    return slice.min()! + slice.max()!
                }
            }
        }

        fatalError("Missing encryption verification!")
    }
}
