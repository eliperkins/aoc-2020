import Algorithms
import Foundation

public enum Day4 {
    static let fields = Set([
        "byr",
        "iyr",
        "eyr",
        "hgt",
        "hcl",
        "ecl",
        "pid",
        "cid"
    ])
    static let hexCharSet = CharacterSet(charactersIn: "0123456789abcdef")
    static let eclSet = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

    // swiftlint:disable:next cyclomatic_complexity
    static func rule(for field: String) -> (String) -> Bool {
        switch field {
        case "byr":
            return { value in
                guard let year = Int(value) else { return false }
                return (1920...2002).contains(year)
            }
        case "iyr":
            return { value in
                guard let year = Int(value) else { return false }
                return (2010...2020).contains(year)
            }
        case "eyr":
            return { value in
                guard let year = Int(value) else { return false }
                return (2020...2030).contains(year)
            }
        case "hgt":
            return { value in
                switch value.suffix(2) {
                case "cm":
                    return (150...193).contains(Int(value.dropLast(2))!)
                case "in":
                    return (59...76).contains(Int(value.dropLast(2))!)
                default:
                    return false
                }
            }
        case "hcl":
            return { value in
                value.count == 7
                    && value.starts(with: "#")
                    && value.dropFirst().allSatisfy { hexCharSet.contains($0.unicodeScalars.first!) }
            }
        case "ecl":
            return eclSet.contains
        case "pid":
            return { value in
                value.count == 9
                    && value.allSatisfy { Int(String($0)) != nil }
            }
        case "cid":
            return { _ in
                return true
            }
        default:
            return { _ in
                return true
            }
        }
    }

    static func passports(from input: String) -> [[String]] {
        return input
            .lines
            .split(whereSeparator: \.isEmpty)
            .map {
                $0.reduce(into: [String]()) { acc, next in
                    let kvs = next.split(separator: " ").map(String.init)
                    acc.append(contentsOf: kvs)
                }
            }
    }

    public static func solvePartOne(from input: String) -> Int {
        passports(from: input)
            .filter { passport in
                switch passport.count {
                case 7:
                    return fields.allSatisfy { element in
                        if element == "cid" {
                            return true
                        }
                        return passport.contains(where: { $0.starts(with: element) })
                    }
                case 8:
                    return fields.allSatisfy { element in
                        passport.contains(where: { $0.starts(with: element) })
                    }
                default:
                    return false
                }
            }
            .count
    }

    public static func solvePartTwo(from input: String) -> Int {
        passports(from: input)
            .filter { passport in
                switch passport.count {
                case 7:
                    return fields.allSatisfy { element in
                        if element == "cid" {
                            return true
                        }

                        guard let item = passport.first(where: { $0.starts(with: element) }) else { return false }
                        let keyValue = item.split(separator: ":")

                        guard let key = keyValue.first.flatMap(String.init),
                            let value = keyValue.last.flatMap(String.init)
                            else { return false }

                        return rule(for: key)(value)
                    }
                case 8:
                    return fields.allSatisfy { element in
                        guard let item = passport.first(where: { $0.starts(with: element) }) else { return false }
                        let keyValue = item.split(separator: ":")

                        guard let key = keyValue.first.flatMap(String.init),
                            let value = keyValue.last.flatMap(String.init)
                            else { return false }

                        return rule(for: key)(value)
                    }
                default:
                    return false
                }
            }
            .count
    }
}
