import Foundation

func parseInput(_ input: String) -> [(Int, Int, Character, String)] {
    input.split(whereSeparator: \.isNewline)
        .compactMap { line -> (Int, Int, Character, String)? in
            let parts = line.split(separator: ":")
            guard let rule = parts.first,
                let passwordValue = parts.last
                else { return nil }
            let ruleValues = rule.split(separator: " ")
            guard let rangeString = ruleValues.first,
                let character = ruleValues.last
                else { return nil }

            let password = String(passwordValue).trimmingCharacters(in: .whitespacesAndNewlines)
            let rangeVals = rangeString.split(separator: "-")
            guard let lowerVal = rangeVals.first,
                let upperVal = rangeVals.last,
                let lower = Int(lowerVal),
                let upper = Int(upperVal)
                else { return nil }
            return (lower, upper, character.first!, password)
        }
}

public enum Day2 {
    public static func countValidPasswords(from input: String) -> Int {
        parseInput(input)
            .filter { (lower, upper, character, password) in
                let range = lower...upper
                return range.contains(password.filter { $0 == character }.count)
            }
            .count
    }

    public static func countNewValidPasswords(from input: String) -> Int {
        parseInput(input)
            .filter { (lower, upper, character, password) in
                let characters = Array(password.unicodeScalars).map { Character($0) }
                let firstMatch = characters[lower - 1] == character
                let secondMatch = characters[upper - 1] == character
                switch (firstMatch, secondMatch) {
                case (true, false), (false, true):
                    return true
                default:
                    return false
                }
            }
            .count
    }
}
