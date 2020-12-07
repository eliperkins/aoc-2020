import Foundation

public enum Day7 {
    struct Rule {
        let sourceBag: String
        let targetBags: [(Int, String)]

        init(sourceBag: String, targetBags: [(Int, String)]) {
            self.sourceBag = sourceBag
            self.targetBags = targetBags
        }

        func canContain(bag bagIdentifier: String) -> Bool {
            let matchingRules = targetBags.filter({ $1 == bagIdentifier })

            if matchingRules.isEmpty {
                return false
            }

            return matchingRules.allSatisfy { rule in
                let (count, targetBag) = rule
                if count == 0 && targetBag == "other" {
                    return false
                }

                if targetBag == bagIdentifier {
                    return count > 0
                }

                return true
            }
        }
    }

    static func parseRules(from input: String) -> [Rule] {
        input.lines.compactMap { line in
            let components = line.components(separatedBy: " contain ")
            guard let source = components.first,
                source.hasSuffix(" bags"),
                let targetRules = components.last?
                    .split(separator: ",")
                    .map({ $0.trimmingCharacters(in: CharacterSet.whitespaces.union(.punctuationCharacters)) })
                    .map({ rulePart -> (Int, String) in
                        var number = rulePart.prefix(while: { char in
                            CharacterSet.decimalDigits.contains(char.unicodeScalars.first!)
                        })
                        // forgive me for my non-regex sins
                        var bagIdentifier = rulePart.dropFirst(number.count)
                            .trimmingCharacters(in: .whitespaces)
                            .split(separator: " ")
                            .dropLast()
                            .joined(separator: " ")
                        if number.count == 0 {
                            number = "0"
                            bagIdentifier = String(bagIdentifier.dropFirst("no ".count))
                        }
                        return (Int(String(number))!, bagIdentifier)
                     })
                else { return nil }

            return Rule(
                sourceBag: String(source.dropLast(" bags".count)),
                targetBags: targetRules
            )
        }
    }

    static func solve(for bagIdentifier: String, with rules: [Rule]) -> Set<String> {
        rules.reduce(Set<String>()) { acc, next in
            if next.canContain(bag: bagIdentifier) {
                var newSet = acc
                newSet.insert(next.sourceBag)
                return newSet.union(solve(for: next.sourceBag, with: rules))
            }
            return acc
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let rules = parseRules(from: input)
        return solve(for: "shiny gold", with: rules).count
    }

    public static func solvePartTwo(from input: String) -> Int {
        let rules = parseRules(from: input)

        let traversalLookupMap = Dictionary(
            rules.map { ($0.sourceBag, $0.targetBags) },
            uniquingKeysWith: { (lhs, _) in lhs }
        )

        func calculate(for bagIdentifier: String) -> Int {
            guard let rulesForBag = traversalLookupMap[bagIdentifier] else {
                return 1
            }

            return rulesForBag.reduce(1) { acc, next in
                acc + next.0 * calculate(for: next.1)
            }
        }

        return calculate(for: "shiny gold") - 1
    }
}
