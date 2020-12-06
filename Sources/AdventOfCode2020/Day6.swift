public enum Day6 {
    public static func solvePartOne(from input: String) -> Int {
        input.lines
            .split(whereSeparator: \.isEmpty)
            .map { group in
                Set(group.map { Array($0) }.reduce([], +)).count
            }
            .reduce(0, +)
    }

    public static func solvePartTwo(from input: String) -> Int {
        input.lines
            .split(whereSeparator: \.isEmpty)
            .map { group in
                let allAnswers = Set(group.map { Array($0) }.reduce([], +))
                return allAnswers.reduce(0) { acc, next in
                    if group.allSatisfy({ line in Set(line).contains(next) }) {
                        return acc + 1
                    }
                    return acc
                }
            }
            .reduce(0, +)
    }
}
