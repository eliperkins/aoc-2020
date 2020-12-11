import AdventOfCode2020
import XCTest

final class Day10Tests: XCTestCase {
    func test_part1_test() {
        XCTAssertEqual(Day10.solvePartOne(from: testInput), 35)
        XCTAssertEqual(Day10.solvePartOne(from: test2Input), 220)
    }

    func test_part1_solution() {
        XCTAssertEqual(Day10.solvePartOne(from: solutionInput), 1914)
    }

    func test_part2_test() {
        XCTAssertEqual(Day10.solvePartTwo(from: testInput), 8)
        XCTAssertEqual(Day10.solvePartTwo(from: test2Input), 19208)
    }

    func test_part2_solution() {
        XCTAssertEqual(Day10.solvePartTwo(from: solutionInput), 9256148959232)
    }
}

private let testInput = """
16
10
15
5
1
11
7
19
6
12
4
"""

private let test2Input = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

private let solutionInput = """
26
97
31
7
2
10
46
38
112
54
30
93
18
111
29
75
139
23
132
85
78
99
8
113
87
57
133
41
104
98
58
90
13
91
20
68
103
127
105
114
138
126
67
32
145
115
16
141
1
73
45
119
51
40
35
150
118
53
80
79
65
135
74
47
128
64
17
4
84
83
147
142
146
9
125
94
140
131
134
92
66
122
19
86
50
52
108
100
71
61
44
39
3
72
"""
