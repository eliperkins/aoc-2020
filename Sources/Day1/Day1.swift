import Algorithms

func findMatch(_ values: [Int], size: Int) -> Int? {
    values.combinations(ofCount: size)
        .first(where: { $0.reduce(0, +) == 2020 })?
        .reduce(1, *)
}

public func solve(_ input: String) -> Int {
    let values = input.split(whereSeparator: \.isNewline).compactMap { Int($0) }
    guard let match = findMatch(values, size: 2) else { fatalError("No matches!") }
    return match
}

public func solvePartTwo(_ input: String) -> Int {
    let values = input.split(whereSeparator: \.isNewline).compactMap { Int($0) }
    guard let match = findMatch(values, size: 3) else { fatalError("No matches!") }
    return match
}