import Foundation

public enum Day11 {
    enum Square: Equatable, Hashable, CustomDebugStringConvertible {
        case seat(filled: Bool)
        case floor

        init?(rawValue: String) {
            switch rawValue {
            case "L":
                self = .seat(filled: false)
            case "#":
                self = .seat(filled: true)
            case ".":
                self = .floor
            default:
                return nil
            }
        }

        var debugDescription: String {
            switch self {
            case .floor: return "."
            case .seat(filled: true): return "#"
            case .seat(filled: false): return "L"
            }
        }
    }

    static func createMap(from input: String) -> Map {
        Map(rawValue: input.lines.map { line in line.compactMap { Square(rawValue: String($0)) } })
    }

    struct Map: Equatable, Hashable, CustomDebugStringConvertible {
        var rawValue: [[Square]]

        init(rawValue: [[Square]]) {
            self.rawValue = rawValue
        }

        func squareAt(row: Int, column: Int) -> Square? {
            guard rawValue.indices.contains(row) else { return nil }
            let row = rawValue[row]
            guard row.indices.contains(column) else { return nil }
            return row[column]
        }

        var debugDescription: String {
            rawValue
                .map { $0.map(\.debugDescription).joined() }
                .joined(separator: "\n")
        }

        var filledSeatCount: Int {
            rawValue.reduce(0) { acc, next in
                acc + next.filter({ $0 == .seat(filled: true ) }).count
            }
        }
    }

    static let directionalSlopes = [
        (0, 1),
        (0, -1),
        (1, 0),
        (-1, 0),
        (1, 1),
        (1, -1),
        (-1, 1),
        (-1, -1)
    ]

    static func run(on map: Map) -> Map {
        var mutableMap = map

        func mutate(row: Int, column: Int) {
            guard let square = map.squareAt(row: row, column: column)
                else { fatalError("Attempted to mutate invalid square position!") }

            let adjacentPositions = directionalSlopes.map { ($0 + row, $1 + column) }

            switch square {
            case .seat(filled: false):
                let allEmpty = adjacentPositions.allSatisfy { (row, column) in
                    guard let adjacentSquare = map.squareAt(row: row, column: column) else { return true }
                    switch adjacentSquare {
                    case .floor, .seat(filled: false):
                        return true
                    case .seat(filled: true):
                        return false
                    }
                }

                if allEmpty {
                    mutableMap.rawValue[row][column] = .seat(filled: true)
                }
            case .seat(filled: true):
                let filledSeats = adjacentPositions.compactMap(map.squareAt)
                    .filter { $0 == .seat(filled: true) }
                    .count
                if filledSeats >= 4 {
                    mutableMap.rawValue[row][column] = .seat(filled: false)
                }
            case .floor:
                break
            }
        }

        map.rawValue.enumerated().forEach { (rowIndex, row) in
            row.indices.forEach { columnIndex in
                mutate(row: rowIndex, column: columnIndex)
            }
        }

        return mutableMap
    }

    static func runPartTwo(on map: Map) -> Map {
        var mutableMap = map

        func mutate(row: Int, column: Int) {
            guard let square = map.squareAt(row: row, column: column)
                else { fatalError("Attempted to mutate invalid square position!") }

            func findFirstSeat(for slope: (Int, Int), from position: (Int, Int)) -> (Int, Int)? {
                let square = map.squareAt(row: position.0 + slope.0, column: position.1 + slope.1)
                switch square {
                case .seat:
                    return (position.0 + slope.0, position.1 + slope.1)
                case .floor:
                    return findFirstSeat(for: slope, from: (position.0 + slope.0, position.1 + slope.1))
                case .none:
                    return nil
                }
            }

            switch square {
            case .seat(filled: false):
                let allEmpty = directionalSlopes
                    .compactMap({ findFirstSeat(for: $0, from: (row, column)) })
                    .allSatisfy { (row, column) in
                        guard let adjacentSquare = map.squareAt(row: row, column: column) else { return true }
                        switch adjacentSquare {
                        case .floor, .seat(filled: false):
                            return true
                        case .seat(filled: true):
                            return false
                        }
                    }

                if allEmpty {
                    mutableMap.rawValue[row][column] = .seat(filled: true)
                }
            case .seat(filled: true):
                let filledSeats = directionalSlopes
                    .compactMap({ findFirstSeat(for: $0, from: (row, column)) })
                    .compactMap(map.squareAt)
                    .filter { $0 == .seat(filled: true) }
                    .count
                if filledSeats >= 5 {
                    mutableMap.rawValue[row][column] = .seat(filled: false)
                }
            case .floor:
                break
            }
        }

        map.rawValue.enumerated().forEach { (rowIndex, row) in
            row.indices.forEach { columnIndex in
                mutate(row: rowIndex, column: columnIndex)
            }
        }

        return mutableMap
    }

    public static func solvePartOne(from input: String) -> Int {
        let startingMap = createMap(from: input)
        func iterate(on map: Map) -> Map {
            let mutation = run(on: map)
            if map == mutation {
                return mutation
            }
            return iterate(on: mutation)
        }
        return iterate(on: startingMap).filledSeatCount
    }

    public static func solvePartTwo(from input: String) -> Int {
        let startingMap = createMap(from: input)
        func iterate(on map: Map) -> Map {
            let mutation = runPartTwo(on: map)
            if map == mutation {
                return mutation
            }
            return iterate(on: mutation)
        }
        return iterate(on: startingMap).filledSeatCount
    }
}
