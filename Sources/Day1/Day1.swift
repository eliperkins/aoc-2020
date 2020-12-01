public func solve(_ input: String) -> Int {
    func findMatch(_ values: [Int]) -> (Int, Int)? {
        guard let lhs = values.first else { return nil }
        let rest = values.dropFirst()
        for rhs in rest {
            if lhs + rhs == 2020 {
                return (lhs, rhs)
            }
        }
        return findMatch(Array(rest))
    }

    let values = input.split(whereSeparator: \.isNewline).compactMap { Int($0) }
    guard let match = findMatch(values) else { fatalError("No matches!") }
    return match.0 * match.1
}

public func solvePartTwo(_ input: String) -> Int {
    func findMatch(_ values: [Int]) -> (Int, Int, Int)? {
        guard let first = values.first else { return nil }
        let rest = values.dropFirst()
        for second in rest {
            for third in rest.dropFirst() {
                if first + second + third == 2020 {
                    return (first, second, third)
                }
            }
        }
        return findMatch(Array(rest))
    }

    let values = input.split(whereSeparator: \.isNewline).compactMap { Int($0) }
    guard let match = findMatch(values) else { fatalError("No matches!") }
    return match.0 * match.1 * match.2
}