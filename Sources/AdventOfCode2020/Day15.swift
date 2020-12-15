public enum Day15 {
    struct ElfGame: Sequence, IteratorProtocol {
        let startingNumbers: [Int]
        private var turn: Int = 0
        private var usedNumbers = [Int: [Int]]()
        private var lastNumber: Int?

        init(startingNumbers: [Int]) {
            self.startingNumbers = startingNumbers
        }

        mutating func next() -> Int? {
            let returnValue: Int
            if startingNumbers.indices.contains(turn) {
                returnValue = startingNumbers[turn]
            } else if let lastNum = lastNumber {
                if let lastUses = usedNumbers[lastNum], lastUses.count > 1 {
                    let uses = lastUses.suffix(2)
                    if let oldest = uses.first, let latest = uses.last {
                        returnValue = latest - oldest
                    } else {
                        returnValue = 0
                    }
                } else {
                    returnValue = 0
                }
            } else {
                returnValue = 0
            }

            lastNumber = returnValue
            if let lastUses = usedNumbers[returnValue], let lastUse = lastUses.last {
                usedNumbers[returnValue] = [lastUse, turn]
            } else {
                usedNumbers[returnValue] = [turn]
            }
            turn += 1

            return returnValue
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let startingNums = input.split(separator: ",").compactMap { Int(String($0)) }
        var x = ElfGame(startingNumbers: startingNums)
        var value: Int? = 0
        for _ in 1...2020 {
            value = x.next()
        }
        return value ?? 0
    }

    public static func solvePartTwo(from input: String) -> Int {
        let startingNums = input.split(separator: ",").compactMap { Int(String($0)) }
        var x = ElfGame(startingNumbers: startingNums)
        var value: Int? = 0
        for _ in 1...30000000 {
            value = x.next()
        }
        return value ?? 0
    }
}
