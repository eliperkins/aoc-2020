import Foundation

public enum Day14 {
    enum Instruction {
        case mask(String)
        case mem(address: Int, value: Int)

        init?(rawValue: String) {
            if rawValue.hasPrefix("mem") {
                let parts = rawValue.dropFirst("mem".count).split(separator: "=")
                guard let addressString = parts
                        .first?
                        .trimmingCharacters(in: CharacterSet(charactersIn: "[]").union(.whitespaces)),
                    let address = Int(addressString),
                    let valueString = parts.last?.trimmingCharacters(in: .whitespaces),
                    let value = Int(valueString)
                    else { return nil }
                self = .mem(address: address, value: value)
            } else if rawValue.hasPrefix("mask") {
                guard let mask = rawValue.split(separator: "=").last?.trimmingCharacters(in: .whitespaces)
                    else { return nil }
                self = .mask(mask)
            } else {
                return nil
            }
        }
    }

    static func apply(mask: String, to value: Int) -> Int {
        let binaryValue = String(value, radix: 2)
        var toWrite = Array(repeating: "0", count: 36 - binaryValue.count) + Array(binaryValue)

        for (index, char) in mask.enumerated() where String(char) != "X" {
            toWrite[index] = char
        }

        return Int(toWrite.map(String.init).joined(), radix: 2) ?? 0
    }

    public static func solvePartOne(from input: String) -> Int {
        input.lines
            .compactMap(Instruction.init)
            .reduce(([Int: Int](), Instruction.mask(Array(repeating: "X", count: 36).joined()))) { acc, next in
                let (memory, mask) = acc
                switch next {
                case .mask:
                    return (memory, next)
                case .mem(let address, let value):
                    guard case let .mask(currentMask) = mask else { fatalError() }
                    let out = apply(mask: currentMask, to: value)
                    var newMem = memory
                    newMem[address] = out
                    return (newMem, mask)
                }
            }
            .0
            .values
            .reduce(0, +)
    }

    public static func solvePartTwo(from input: String) -> Int {
        // lol jesus this function sucks.
        func calculateAddresses(from mask: String, for address: Int) -> [Int] {
            let indiciesToReplace = mask.enumerated().filter { (_, char) in String(char) == "X" }
            let combinations = 2 ^^ indiciesToReplace.count
            let max = String(combinations - 1, radix: 2).count
            return (0..<combinations).compactMap { value in
                let replacementValues = Array(String(value, radix: 2).leftPadding(to: max).map(String.init))
                var mutMask = Array(String(address, radix: 2).leftPadding(to: mask.count).map(String.init))

                // apply bitmask
                for (index, char) in mask.enumerated() where char == "1" {
                    mutMask[index] = "1"
                }

                indiciesToReplace.enumerated().forEach { (count, replacing) in
                    let (index, _) = replacing
                    mutMask[index] = replacementValues[count]
                }

                return Int(mutMask.joined(), radix: 2)
            }
        }

        return input.lines
            .compactMap(Instruction.init)
            .reduce(([Int: Int](), Instruction.mask(Array(repeating: "X", count: 36).joined()))) { acc, next in
                let (memory, mask) = acc
                switch next {
                case .mask:
                    return (memory, next)
                case .mem(let address, let value):
                    guard case let .mask(currentMask) = mask else { fatalError() }
                    var newMem = memory
                    for float in calculateAddresses(from: currentMask, for: address) {
                        newMem[float] = value
                    }
                    return (newMem, mask)
                }
            }
            .0
            .values
            .reduce(0, +)
    }
}

extension String {
    func leftPadding(to size: Int, with string: String = "0") -> String {
        Array(repeating: string, count: size - self.count).joined() + self
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
