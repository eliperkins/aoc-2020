import Algorithms
import Flexer

enum TokenKind {
    case number
    case addition
    case multiplication
    case parensOpen
    case parensClose
    case whitespace
}

typealias Day18Token = Flexer.Token<TokenKind>

struct Day18Sequence: Sequence, IteratorProtocol, StringInitializable {
    typealias Element = Day18Token

    private var lexer: BasicTextCharacterLexer

    init(string: String) {
        self.lexer = BasicTextCharacterLexer(string: string)
    }

    mutating func next() -> Element? {
        guard let token = lexer.peek() else {
            return nil
        }

        switch token.kind {
        case .plus:
            _ = lexer.next()
            return Day18Token(kind: .addition, range: token.range)
        case .star:
            _ = lexer.next()
            return Day18Token(kind: .multiplication, range: token.range)
        case .openParen:
            _ = lexer.next()
            return Day18Token(kind: .parensOpen, range: token.range)
        case .closeParen:
            _ = lexer.next()
            return Day18Token(kind: .parensClose, range: token.range)
        case .digit:
            guard let endingToken = lexer.nextUntil({ $0.kind != .digit }) else {
                return nil
            }
            return Day18Token(kind: .number, range: token.startIndex..<endingToken.endIndex)
        case .newline, .tab, .space:
            guard let endingToken = lexer.nextUntil(notIn: [.newline, .tab, .space]) else {
                return nil
            }
            return Day18Token(kind: .whitespace, range: token.startIndex..<endingToken.endIndex)
        default:
            break
        }

        return nil
    }
}

typealias Day18TokenLexer = LookAheadSequence<Day18Sequence>

public enum Day18 {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public static func solve(_ expression: String) -> Int {
        var seq = Day18TokenLexer(string: expression)
        var returnValue = 0

        enum Operation {
            case addition
            case multiplication
        }

        var currentOperation = Operation.addition

        var next = seq.next()
        while let token = next {
            switch token.kind {
            case .addition:
                currentOperation = .addition
            case .multiplication:
                currentOperation = .multiplication
            case .number:
                guard let value = Int(expression[token.startIndex..<token.endIndex]) else {
                    fatalError()
                }
                switch currentOperation {
                case .addition:
                    returnValue += value
                case .multiplication:
                    returnValue *= value
                }
            case .parensOpen:
                var depth = 1
                guard let endingToken = seq.nextUntil({
                    if $0.kind == .parensClose {
                        depth -= 1
                    } else if $0.kind == .parensOpen {
                        depth += 1
                    }
                    return depth == 0
                })
                    else { fatalError("Missing matching parens!") }
                let string = String(
                    expression[
                        expression.index(token.startIndex, offsetBy: 1)..<endingToken.endIndex
                    ]
                )
                let value = solve(string)
                switch currentOperation {
                case .addition:
                    returnValue += value
                case .multiplication:
                    returnValue *= value
                }
            case .parensClose:
                break
            case .whitespace:
                break
            }

            next = seq.next()
        }

        return returnValue
    }

    public static func solvePartOne(from input: String) -> Int {
        input.lines.map(solve).reduce(0, +)
    }

    public static func solve2(_ expression: String) -> Int {
        0
    }

    public static func solvePartTwo(from input: String) -> Int {
        0
    }
}
