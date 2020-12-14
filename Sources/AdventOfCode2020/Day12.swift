public enum Day12 {
    public enum Direction: String {
        case north = "N"
        case south = "S"
        case east = "E"
        case west = "W"
        case left = "L"
        case right = "R"
        case forward = "F"

        static let compassDirections: [Direction] = [
            .north,
            .east,
            .south,
            .west
        ]

        var degreeHeading: Int {
            switch self {
            case .north:
                return 0
            case .south:
                return 180
            case .east:
                return 90
            case .west:
                return 270
            default:
                fatalError("Invalid call to heading!")
            }
        }

        public func apply(turn: Direction, of degrees: Int) -> Direction {
            switch turn {
            case .left:
                let directions = Array(Direction.compassDirections.reversed())
                guard let currentHeadingIndex = directions.firstIndex(of: self) else { fatalError() }
                let turns = degrees/90 % directions.count
                return directions[currentHeadingIndex.advanced(by: turns) % 4]
            case .right:
                guard let currentHeadingIndex = Direction.compassDirections.firstIndex(of: self) else { fatalError() }
                let turns = degrees/90 % Direction.compassDirections.count
                return Direction.compassDirections[currentHeadingIndex.advanced(by: turns) % 4]
            default:
                return self
            }
        }
    }

    static func parseInstructions(from input: String) -> [(Direction, Int)] {
        input.lines.compactMap { line in
            guard let direction = line.first.flatMap(String.init).flatMap(Direction.init),
                let value = Int(line.dropFirst())
                else { return nil }
            return (direction, value)
        }
    }

    public static func solvePartOne(from input: String) -> Int {
        let instructions = parseInstructions(from: input)
        let initialValue: (Int, Int, Direction) = (0, 0, Direction.east)
        let endPosition = instructions.reduce(initialValue) { acc, next in
            let (direction, value) = next
            func apply(direction: Direction, to current: (Int, Int, Direction)) -> (Int, Int, Direction) {
                let (x, y, heading) = current
                switch direction {
                case .north:
                    return (x, y + value, heading)
                case .south:
                    return (x, y - value, heading)
                case .east:
                    return (x + value, y, heading)
                case .west:
                    return (x - value, y, heading)
                case .left:
                    return (x, y, heading.apply(turn: .left, of: value))
                case .right:
                    return (x, y, heading.apply(turn: .right, of: value))
                case .forward:
                    return apply(direction: heading, to: current)
                }
            }
            return apply(direction: direction, to: acc)
        }
        return abs(endPosition.0) + abs(endPosition.1)
    }

    public static func rotate(waypoint: (Int, Int), direction: Direction, value: Int) -> (Int, Int) {
        let (x, y) = waypoint
        switch direction {
        case .left:            
            switch value / 90 % 4 {
            case 0:
                return waypoint
            case 1:
                return (-y, x)
            case 2:
                return (-x, -y)
            case 3:
                return (y, -x)
            default:
                fatalError()
            }
        case .right:
            switch value / 90 % 4 {
            case 0:
                return waypoint
            case 1:
                return (y, -x)
            case 2:
                return (-x, -y)
            case 3:
                return (-y, x)
            default:
                fatalError()
            }        
        default: 
            fatalError("Invalid rotation!")
        }
    }

    public static func solvePartTwo(from input: String) -> Int {
        let instructions = parseInstructions(from: input)
        let initialValue: (Int, Int, (Int, Int)) = (0, 0, (10, 1))

        let endPosition = instructions.reduce(initialValue) { acc, next in
            let (direction, value) = next
            
            func apply(direction: Direction, to current: (Int, Int, (Int, Int))) -> (Int, Int, (Int, Int)) {
                let (x, y, waypoint) = current
                let (waypointX, waypointY) = waypoint
                switch direction {
                case .north:
                    return (x, y, (waypointX, waypointY + value))
                case .south:
                    return (x, y, (waypointX, waypointY - value))
                case .east:
                    return (x, y, (waypointX + value, waypointY))
                case .west:
                    return (x, y, (waypointX - value, waypointY))
                case .left:
                    return (x, y, rotate(waypoint: waypoint, direction: .left, value: value))
                case .right:
                    return (x, y, rotate(waypoint: waypoint, direction: .right, value: value))
                case .forward:
                    return (x + (value * waypointX), y + (value * waypointY), waypoint)
                }
            }

            return apply(direction: direction, to: acc)
        }
        return abs(endPosition.0) + abs(endPosition.1)
    }
}
