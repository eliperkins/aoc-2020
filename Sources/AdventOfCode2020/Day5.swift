public enum Day5 {
    public struct Seat: Equatable, Hashable {
        public let row: Int
        public let column: Int
        public let id: Int

        // swiftlint:disable:next cyclomatic_complexity
        public init?(from input: String) {
            guard input.count == 10 else { return nil }
            let rowString = input.prefix(7)
            var rowRange = 0...127
            for char in rowString {
                switch char {
                case "F":
                    rowRange = rowRange.lowerBound...(rowRange.upperBound - rowRange.count/2)
                case "B":
                    rowRange = (rowRange.lowerBound + rowRange.count/2)...rowRange.upperBound
                default:
                    fatalError("Invalid row input!")
                }
            }
            guard rowRange.count == 1, let row = rowRange.first else {
                fatalError("Row range too large!")
            }
            self.row = row

            let columnString = input.suffix(3)
            var columnRange = 0...7
            for char in columnString {
                switch char {
                case "L":
                    columnRange = columnRange.lowerBound...(columnRange.upperBound - columnRange.count/2)
                case "R":
                    columnRange = (columnRange.lowerBound + columnRange.count/2)...columnRange.upperBound
                default:
                    fatalError("Invalid column input!")
                }
            }
            guard columnRange.count == 1, let column = columnRange.first else {
                fatalError("Column range too large!")
            }
            self.column = column
            self.id = row * 8 + column
        }

        public init(row: Int, column: Int) {
            self.row = row
            self.column = column
            self.id = row * 8 + column
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        input.split(whereSeparator: \.isNewline)
            .compactMap { line in
                return Seat(from: String(line))
            }
            .map(\.id)
            .max() ?? 0
    }

    public static func solvePartTwo(from input: String) -> Seat {
        let passesFromInput = Set(input.split(whereSeparator: \.isNewline)
            .compactMap { line in
                return Seat(from: String(line))
            }
        )
        let rowRange = 0...127
        let columnRange = 0...7
        let allSeats = Set(rowRange.flatMap { row in
            columnRange.map { column in
                Seat(row: row, column: column)
            }
        })
        let passesFromInputIds = passesFromInput.map(\.id)
        guard let seat = allSeats.subtracting(passesFromInput)
            .filter({ $0.row != 0 && $0.row != 127 })
            .first(where: { passesFromInputIds.contains($0.id + 1) && passesFromInputIds.contains($0.id - 1) })
            else { fatalError("Could not find seat from input!") }

        return seat
    }
}
