import Algorithms
import Foundation

public enum Day16 {
    public static func solvePartOne(from input: String) -> Int {
        let groups = input.lines.split(whereSeparator: \.isEmpty)
        assert(groups.count == 3, "Invalid input!")

        let ruleLines = groups[0]
        let yourTicket = groups[1].last!.split(separator: ",").compactMap { Int(String($0)) }
        let nearbyTickets = groups[2].dropFirst().map({ line in
            line.split(separator: ",").compactMap({ Int(String($0)) }) 
        })

        let rules: [(String, (ClosedRange<Int>, ClosedRange<Int>))] = ruleLines
            .map { line in 
                let parts = line.split(separator: ":")
                assert(parts.count == 2)
                let id = String(parts[0])
                let ranges = parts[1].trimmingCharacters(in: .whitespaces)
                    .components(separatedBy: " or ")
                    .map { string -> ClosedRange<Int> in
                        let rangeParts = string.split(separator: "-")
                        assert(rangeParts.count == 2)
                        guard let start = Int(rangeParts[0]), let end = Int(rangeParts[1]) else {
                            fatalError()
                        }
                        return start...end
                    }
                assert(ranges.count == 2)
                return (id, (ranges[0], ranges[1]))
            }

        func checkValidity(_ ticket: [Int]) -> Int? {
            ticket.first(where: { value in
                rules.first(where: { rule in
                    let (_, (first, second)) = rule
                    return first.contains(value) || second.contains(value)
                }) == nil
            })
        }
        
        return nearbyTickets.reduce(0) { acc, next in
            if let value = checkValidity(next) {
                return acc + value
            }
            return acc
        }
    }

    public static func solvePartTwo(from input: String) -> Int {
        0
    }
}
