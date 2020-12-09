public enum Day8 {

    enum Operation: String {
        case acc
        case jmp
        case nop
    }

    struct Instruction: Equatable, Hashable, CustomDebugStringConvertible {
        let operation: Operation
        let value: Int
        let index: Int

        init(operation: Operation, value: Int, index: Int) {
            self.operation = operation
            self.value = value
            self.index = index
        }

        init?(index: Int, line: String) {
            let parts = line.split(separator: " ")
            guard let operationValue = parts.first,
                let operation = Operation(rawValue: String(operationValue)),
                let valueValue = parts.last,
                let value = Int(valueValue)
                else { return nil }
            self.operation = operation
            self.value = value
            self.index = index
        }

        var debugDescription: String {
            "<\(index)> \(operation.rawValue) \(value > 0 ? "+" : "")\(value)"
        }
    }

    static func runProgram(_ instructions: [Instruction]) -> (Bool, Int) {
        var acc = 0
        var head = 0
        var completedInstructions = Set<Instruction>()

        while instructions.indices.contains(head) {
            let instruction = instructions[head]
            // print("running: \(instruction)")

            if completedInstructions.contains(instruction) {
                // print("inf loop failure: \(instruction) accVal: \(acc)")
                return (false, acc)
            }

            switch instruction.operation {
            case .acc:
                head = head.advanced(by: 1)
                acc += instruction.value
            case .jmp:
                head = head.advanced(by: instruction.value)
            case .nop:
                head = head.advanced(by: 1)
            }

            completedInstructions.insert(instruction)
        }

        return (true, acc)
    }

    public static func solvePartOne(from input: String) -> Int {
        let instructions = input.lines.enumerated().compactMap(Instruction.init)
        return runProgram(instructions).1
    }

    public static func solvePartTwo(from input: String) -> Int {
        let instructions = input.lines.enumerated().compactMap(Instruction.init)
        let changeableInstructions = instructions.filter { $0.operation == .jmp || $0.operation == .nop }

        for changeableInstruction in changeableInstructions {
            var instructionsMutation = instructions
            switch changeableInstruction.operation {
            case .nop:
                instructionsMutation[changeableInstruction.index] = Instruction(
                    operation: .jmp,
                    value: changeableInstruction.value,
                    index: changeableInstruction.index
                )
            case .jmp:
                instructionsMutation[changeableInstruction.index] = Instruction(
                    operation: .nop,
                    value: changeableInstruction.value,
                    index: changeableInstruction.index
                )
            case .acc:
                fatalError("Attempted to change unchangable instruction")
            }

            let (completed, value) = runProgram(instructionsMutation)

            if completed {
                return value
            }
        }

        return 0
    }
}
