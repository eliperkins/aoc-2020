import Algorithms

public enum Day13 {
    public static func solvePartOne(from input: String) -> Int {
        let lines = input.lines

        guard let departureTime = lines.first.flatMap({ Int(String($0)) }),
            let busIDs = lines.last?.split(separator: ",").filter({ $0 != "x" }).compactMap({ Int(String($0)) })
            else { fatalError() }

        for earliestBusTime in departureTime... {
            for busID in busIDs where earliestBusTime % busID == 0 {
                return (earliestBusTime - departureTime) * busID
            }
        }

        fatalError("Failed to find bus!")
    }

    public static func solvePartTwo(from input: String) -> Int {
        guard let busIDs = input.lines.last?.split(separator: ",").map({ Int(String($0)) }) else { fatalError() }
        let busIDsAndIndicies = busIDs.enumerated()
            .compactMap({ (index, id) -> (Int, Int)? in
                if let id = id {
                    return (index, id)
                }
                return nil
            })

        var incrementingFactor: Int = busIDs.first!!
        var currentMatches = Set<Int>([incrementingFactor])

        var currentEstimate = 0
        while true {
            currentEstimate += incrementingFactor

            if busIDsAndIndicies.allSatisfy({ (index, id) in (currentEstimate + index) % id == 0 }) {
                return currentEstimate
            }

            if let firstMatch = busIDsAndIndicies.first(where: { (index, id) in
                (currentEstimate + index) % id == 0 && !currentMatches.contains(id)
            }) {
                incrementingFactor *= firstMatch.1
                currentMatches.insert(firstMatch.1)
            }
        }
    }
}
