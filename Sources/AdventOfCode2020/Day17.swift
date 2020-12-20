protocol Positionable {
    static func positions(around position: Self) -> [Self]
}

extension SIMD3: Positionable where SIMD3.Scalar == Int {
    static func positions(around position: SIMD3<Int>) -> [SIMD3<Int>] {
        [-1, 0, 1].flatMap { dx in
            [-1, 0, 1].flatMap { dy in
                [-1, 0, 1].compactMap { dz in
                    let next = SIMD3(position.x + dx, position.y + dy, position.z + dz)
                    if next == position {
                        return nil
                    }
                    return next
                }
            }
        }
    }
}

extension SIMD4: Positionable where SIMD4.Scalar == Int {
    static func positions(around position: SIMD4<Int>) -> [SIMD4<Int>] {
        [-1, 0, 1].flatMap { dx in
            [-1, 0, 1].flatMap { dy in
                [-1, 0, 1].flatMap { dz in
                    [-1, 0, 1].compactMap { dw in
                        let next = SIMD4(
                            position.x + dx,
                            position.y + dy,
                            position.z + dz,
                            position.w + dw
                        )
                        if next == position {
                            return nil
                        }
                        return next
                    }
                }
            }
        }
    }
}

public enum Day17 {
    enum State: String {
        case active = "#"
        case inactive = "."
    }

    static func solve<T: Positionable>(_ initialPositions: [T: State]) -> [T: State] {
        var universe = initialPositions
        func run() {
            var mutUniverse = universe

            mutUniverse.keys.forEach { pos in
                T.positions(around: pos).forEach { adjPos in
                    mutUniverse[adjPos] = universe[adjPos, default: .inactive]
                }
            }

            mutUniverse.forEach { (pos, state) in
                let adjacentPos = T.positions(around: pos)

                let adjacent = adjacentPos.map { adjPos in
                    universe[adjPos, default: .inactive]
                }

                switch state {
                case .active:
                    let actives = adjacent.filter { $0 == .active }
                    if actives.count == 2 || actives.count == 3 {
                        mutUniverse[pos] = .active
                    } else {
                        mutUniverse[pos] = .inactive
                    }
                case .inactive:
                    let actives = adjacent.filter { $0 == .active }
                    if actives.count == 3 {
                        mutUniverse[pos] = .active
                    } else {
                        mutUniverse[pos] = .inactive
                    }
                }
            }

            universe = mutUniverse
        }

        (0..<6).forEach { _ in run() }

        return universe
    }

    public static func solvePartOne(from input: String) -> Int {
        let initialPositions: [SIMD3<Int>: State] = Dictionary(
            uniqueKeysWithValues: input
                .lines
                .enumerated()
                .flatMap { (y, line) in
                    line
                        .compactMap({ State(rawValue: String($0)) })
                        .enumerated()
                        .filter { $0.1 == .active }
                        .map { (x, state) in
                            (SIMD3(x, y, 0), state)
                        }
                }
        )

        return solve(initialPositions)
            .filter { $0.1 == .active }
            .count
    }

    public static func solvePartTwo(from input: String) -> Int {
        let initialPositions: [SIMD4<Int>: State] = Dictionary(
            uniqueKeysWithValues: input
                .lines
                .enumerated()
                .flatMap { (y, line) in
                    line
                        .compactMap({ State(rawValue: String($0)) })
                        .enumerated()
                        .filter { $0.1 == .active }
                        .map { (x, state) in
                            (SIMD4(x, y, 0, 0), state)
                        }
                }
        )

        return solve(initialPositions)
            .filter { $0.1 == .active }
            .count
    }
}
