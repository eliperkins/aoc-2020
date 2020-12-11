import Algorithms

public enum Day10 {
    static func calculateJumpList(from list: [Int]) -> [Int] {
        let availableAdapters = [0] + list.sorted()
        return availableAdapters.enumerated().map { (index, adapter) in
            let nextIndex = index.advanced(by: 1)
            if availableAdapters.indices.contains(nextIndex) {
                return availableAdapters[nextIndex] - adapter
            } else {
                return 3
            }
        }
    }

    static func calculateJumpMap(from jumps: [Int]) -> [Int: Int] {
        jumps.reduce(into: [Int: Int]()) { acc, next in
            acc[next] = (acc[next] ?? 0).advanced(by: 1)
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let list = input.lines.compactMap(Int.init)
        let jumpMap = calculateJumpMap(from: calculateJumpList(from: list))
        return jumpMap[1]! * jumpMap[3]!
    }

    public static func solvePartTwo(from input: String) -> Int {
        let list = input.lines.compactMap(Int.init)
        let totalList = calculateJumpList(from: list)
        return totalList
            .chunked(by: { (a, _) in a != 3 })
            .map { $0.filter({ x in x == 1 }).count }
            .map { tribonacci($0 + 1) }
            .reduce(1, *)
    }
}

let memoized = memoize { (value: Int) -> Int in
    if value <= 0 {
        return 0
    }

    if value == 1 {
        return 1
    }

    if value == 2 {
        return 1
    }

    return tribonacci(value - 1) + tribonacci(value - 2) + tribonacci(value - 3)
}

func tribonacci(_ x: Int) -> Int {
    return memoized(x)
}

func memoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
    var storage = [Input: Output]()

    return { input in
        if let cached = storage[input] {
            return cached
        }

        let result = function(input)
        storage[input] = result
        return result
    }
}
