public enum Day15 {
    struct ElfGame: Sequence, IteratorProtocol {
        let startingNumbers: [Int]

        private var turn: Int = 0
        private var usedNumbers = [Int: (Int, Int)]()
        private var lastNumber: Int?

        init(startingNumbers: [Int]) {
            self.startingNumbers = startingNumbers
        }

        mutating func next() -> Int? {
            let returnValue: Int

            if startingNumbers.indices.contains(turn) {
                returnValue = startingNumbers[turn]
            } else if let lastNum = lastNumber {
                if let lastUses = usedNumbers[lastNum] {
                    returnValue = lastUses.1 - lastUses.0
                } else {
                    returnValue = 0
                }
            } else {
                returnValue = 0
            }

            if let lastUses = usedNumbers[returnValue] {
                usedNumbers[returnValue] = (lastUses.1, turn)
            } else {
                usedNumbers[returnValue] = (turn, turn)
            }

            lastNumber = returnValue
            turn += 1

            return returnValue
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let startingNums = input.split(separator: ",").compactMap { Int(String($0)) }
        var x = ElfGame(startingNumbers: startingNums)
        return (1...2020)
            .map({ _ in x.next() ?? 0 })
            .last ?? 0
    }

    public static func solvePartTwo(from input: String) -> Int {
        let startingNums = input.split(separator: ",").compactMap { Int(String($0)) }
        var x = ElfGame(startingNumbers: startingNums)
        return (1...30000000)
            .map({ _ in x.next() ?? 0 })
            .last ?? 0
    }
}
