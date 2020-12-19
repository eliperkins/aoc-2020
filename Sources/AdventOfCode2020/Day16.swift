import Algorithms
import Foundation

public enum Day16 {
    struct Input {
        typealias Rule = (String, (ClosedRange<Int>, ClosedRange<Int>))
        let rules: [Rule]
        let yourTicket: [Int]
        let nearbyTickets: [[Int]]

        init(_ rawValue: String) {
            let groups = rawValue.lines.split(whereSeparator: \.isEmpty)
            assert(groups.count == 3, "Invalid input!")

            self.yourTicket = groups[1].last!.split(separator: ",").compactMap { Int(String($0)) }
            self.nearbyTickets = groups[2].dropFirst().map({ line in
                line.split(separator: ",").compactMap({ Int(String($0)) })
            })

            let ruleLines = groups[0]
            self.rules = ruleLines
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
        }

        func checkValidity(_ ticket: [Int]) -> Int? {
            ticket.first(where: { value in
                rules.first(where: { rule in
                    let (_, (first, second)) = rule
                    return first.contains(value) || second.contains(value)
                }) == nil
            })
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let input = Input(input)
        return input.nearbyTickets.reduce(0) { acc, next in
            if let value = input.checkValidity(next) {
                return acc + value
            }
            return acc
        }
    }

    public static func solvePartTwo(from input: String) -> Int {
        let input = Input(input)
        let validTickets = input.nearbyTickets.filter { input.checkValidity($0) == nil }
        let numTicketFields = input.rules.count

        var matches = input.rules.reduce(into: [String: [Int]]()) { acc, next in
            let (id, (rangeOne, rangeTwo)) = next
            var validFields = [Int]()
            for position in 0..<numTicketFields {
                let valuesAtPosition = validTickets.map { $0[position] }
                let potentialMatch = valuesAtPosition.allSatisfy { value in
                    rangeOne.contains(value) || rangeTwo.contains(value)
                }
                if potentialMatch {
                    validFields.append(position)
                }
            }
            acc[id] = validFields
        }

        var solved = [String?](repeating: nil, count: input.rules.count)
        while solved.compactMap({ $0 }).count != input.rules.count {
            for match in matches {
                if match.value.count == 1, let position = match.value.first {
                    solved[position] = match.key
                    matches.filter({ element in element.value.contains(position) })
                        .forEach { solved in
                            matches[solved.key] = solved.value.filter { $0 != position }
                        }
                }
            }
        }

        let departurePositions = solved
            .compactMap({ $0 })
            .enumerated()
            .filter({ (_, value) in value.contains("departure") })

        return departurePositions.reduce(1) { acc, next in
            acc * input.yourTicket[next.offset]
        }
    }
}
