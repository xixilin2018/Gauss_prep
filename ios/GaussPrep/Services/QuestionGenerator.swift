import Foundation

final class QuestionGenerator {
    func generateQuestion(difficulty: Int, preferredTopic: Topic? = nil) -> GeneratedQuestion {
        let boundedDifficulty = max(1, min(10, difficulty))
        let part = part(for: boundedDifficulty)
        let topic = preferredTopic ?? weightedTopic(for: part)

        switch topic {
        case .numberSenseNumeration:
            return generateNumberSense(difficulty: boundedDifficulty, part: part)
        case .geometrySpatialSense:
            return generateGeometrySpatial(difficulty: boundedDifficulty, part: part)
        case .algebraPatterning:
            return generateAlgebraPatterning(difficulty: boundedDifficulty, part: part)
        case .dataManagementProbability:
            return generateDataProbability(difficulty: boundedDifficulty, part: part)
        }
    }

    func generateQuestion(part: GaussPart, preferredTopic: Topic? = nil) -> GeneratedQuestion {
        let difficulty: Int
        switch part {
        case .partA:
            difficulty = Int.random(in: 1...3)
        case .partB:
            difficulty = Int.random(in: 4...7)
        case .partC:
            difficulty = Int.random(in: 8...10)
        }

        return generateQuestion(difficulty: difficulty, preferredTopic: preferredTopic)
    }

    private func part(for difficulty: Int) -> GaussPart {
        switch difficulty {
        case 1...3:
            return .partA
        case 4...7:
            return .partB
        default:
            return .partC
        }
    }

    private func weightedTopic(for part: GaussPart) -> Topic {
        let roll = Int.random(in: 1...100)
        switch part {
        case .partA:
            if roll <= 45 { return .numberSenseNumeration }
            if roll <= 70 { return .geometrySpatialSense }
            if roll <= 90 { return .algebraPatterning }
            return .dataManagementProbability
        case .partB:
            if roll <= 35 { return .numberSenseNumeration }
            if roll <= 62 { return .geometrySpatialSense }
            if roll <= 85 { return .algebraPatterning }
            return .dataManagementProbability
        case .partC:
            if roll <= 28 { return .numberSenseNumeration }
            if roll <= 55 { return .geometrySpatialSense }
            if roll <= 80 { return .algebraPatterning }
            return .dataManagementProbability
        }
    }

    private func generateNumberSense(difficulty: Int, part: GaussPart) -> GeneratedQuestion {
        switch part {
        case .partA:
            return partANumberSense(difficulty: difficulty)
        case .partB:
            return partBNumberSense(difficulty: difficulty)
        case .partC:
            return partCNumberSense(difficulty: difficulty)
        }
    }

    private func generateGeometrySpatial(difficulty: Int, part: GaussPart) -> GeneratedQuestion {
        switch part {
        case .partA:
            return partAGeometry(difficulty: difficulty)
        case .partB:
            return partBGeometry(difficulty: difficulty)
        case .partC:
            return partCGeometry(difficulty: difficulty)
        }
    }

    private func generateAlgebraPatterning(difficulty: Int, part: GaussPart) -> GeneratedQuestion {
        switch part {
        case .partA:
            return partAAlgebra(difficulty: difficulty)
        case .partB:
            return partBAlgebra(difficulty: difficulty)
        case .partC:
            return partCAlgebra(difficulty: difficulty)
        }
    }

    private func generateDataProbability(difficulty: Int, part: GaussPart) -> GeneratedQuestion {
        switch part {
        case .partA:
            return partAData(difficulty: difficulty)
        case .partB:
            return partBData(difficulty: difficulty)
        case .partC:
            return partCData(difficulty: difficulty)
        }
    }

    private func partANumberSense(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...3)
        if variant == 1 {
            let a = Int.random(in: 20...(80 + difficulty * 10))
            let b = Int.random(in: 20...(80 + difficulty * 10))
            let percent = [10, 20, 25, 50].randomElement() ?? 25
            let sum = a + b
            let value = sum * percent / 100
            let prompt = "What is \(percent)% of (\(a) + \(b))?"
            let choices = shuffledOptions(correct: value, spread: max(6, difficulty * 2))
            return makeQuestion(prompt: prompt, answer: value, choices: choices, explanation: "Add first, then apply the percent.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Percent of a Sum", part: .partA)
        }

        if variant == 2 {
            let value = Int.random(in: 100...(400 + difficulty * 40))
            let divisor = [3, 4, 6, 7, 8].randomElement() ?? 3
            let remainder = value % divisor
            let prompt = "What is the remainder when \(value) is divided by \(divisor)?"
            let choices = shuffledOptions(correct: remainder, minValue: 0, spread: max(3, difficulty))
            return makeQuestion(prompt: prompt, answer: remainder, choices: choices, explanation: "Compute quotient and remainder.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Division Remainder", part: .partA)
        }

        let width = Int.random(in: 3...(9 + difficulty))
        let length = Int.random(in: (width + 1)...(width + 8))
        let area = width * length
        let perimeter = 2 * (width + length)
        let prompt = "A rectangle has area \(area) cm^2 and perimeter \(perimeter) cm. What is its width?"
        let choices = shuffledOptions(correct: width, spread: max(4, difficulty))
        return makeQuestion(prompt: prompt, answer: width, choices: choices, explanation: "Solve the system using area and perimeter.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Area and Perimeter Reasoning", part: .partA)
    }

    private func partBNumberSense(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let n = Int.random(in: 180...(420 + difficulty * 15))
            let prompt = "How many trailing zeros are in \(n) x 25 x 8?"
            let product = n * 25 * 8
            let zeros = String(product).reversed().prefix { $0 == "0" }.count
            let choices = shuffledOptions(correct: zeros, minValue: 0, spread: 2)
            return makeQuestion(prompt: prompt, answer: zeros, choices: choices, explanation: "Trailing zeros come from factors of 10.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Prime Factors", part: .partB)
        }

        let a = Int.random(in: 8...(20 + difficulty))
        let b = Int.random(in: 6...(18 + difficulty))
        let lcm = leastCommonMultiple(a, b)
        let prompt = "A bell rings every \(a) minutes and another every \(b) minutes. If they ring together now, after how many minutes will they ring together again?"
        let choices = shuffledOptions(correct: lcm, spread: max(8, difficulty * 2))
        return makeQuestion(prompt: prompt, answer: lcm, choices: choices, explanation: "Use the least common multiple.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "LCM", part: .partB)
    }

    private func partCNumberSense(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...4)
        if variant == 1 {
            let a = Int.random(in: 11...19)
            let b = Int.random(in: 11...19)
            let c = Int.random(in: 11...19)
            let mod = Int.random(in: 6...12)
            let remainder = (a * b * c) % mod
            let prompt = "What is the remainder when \(a) x \(b) x \(c) is divided by \(mod)?"
            let choices = shuffledOptions(correct: remainder, minValue: 0, spread: 3)
            return makeQuestion(prompt: prompt, answer: remainder, choices: choices, explanation: "Reduce factors modulo the divisor.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Modular Arithmetic", part: .partC)
        }

        if variant == 2 {
            let count = 42
            let prompt = "How many palindromes greater than 10,000 and less than 100,000 are multiples of 18?"
            let choices = shuffledOptions(correct: count, spread: 4)
            return makeQuestion(prompt: prompt, answer: count, choices: choices, explanation: "Use palindrome form and divisibility by 2 and 9.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Palindromes and Divisibility", part: .partC)
        }

        if variant == 3 {
            let choices = ["27", "28", "29", "42", "252"]
            let prompt = "A number is 1 followed by many zeros. After subtracting 1, the digit sum is 252. How many zeros were in the original number?"
            let correctIndex = choices.firstIndex(of: "28") ?? 1
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "10^n - 1 has n digits of 9, so digit sum is 9n.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Digit Sum Logic", part: .partC)
        }

        let choices = ["4", "5", "7", "8", "11"]
        let prompt = "How many different pairs of positive integers have GCF 4 and LCM 4620?"
        let correctIndex = choices.firstIndex(of: "5") ?? 1
        return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Use a = 4x, b = 4y with gcd(x,y)=1 and xy fixed.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "GCF and LCM Counting", part: .partC)
    }

    private func partAGeometry(difficulty: Int) -> GeneratedQuestion {
        let width = Int.random(in: 3...(9 + difficulty))
        let length = Int.random(in: (width + 1)...(width + 8))
        let area = width * length
        let prompt = "What is the area of a rectangle with width \(width) cm and length \(length) cm?"
        let choices = shuffledOptions(correct: area, spread: max(6, difficulty * 2))
        return makeQuestion(prompt: prompt, answer: area, choices: choices, explanation: "Area = width x length.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Area", part: .partA)
    }

    private func partBGeometry(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...3)
        if variant == 1 {
            var baseAngles = (0..<4).map { _ in Int.random(in: 60...120) }
            let sum = baseAngles.reduce(0, +)
            baseAngles[3] += (360 - sum)
            let outlier = baseAngles.randomElement()! + [18, 22, -18, -22].randomElement()!
            var allAngles = baseAngles + [outlier]
            allAngles.shuffle()
            let prompt = "Four of these are angles of one quadrilateral: \(allAngles.map { "\($0) degrees" }.joined(separator: ", ")). Which one is NOT?"
            let choices = allAngles.map { String($0) + " degrees" }
            let correctIndex = choices.firstIndex(of: String(outlier) + " degrees") ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Quadrilateral interior angles sum to 360.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Angle Reasoning", part: .partB)
        }

        if variant == 2 {
            let side = Int.random(in: 4...9)
            let cut = Int.random(in: 1...(side - 1))
            let remainingArea = side * side - cut * cut
            let prompt = "A square of side \(side) cm has a smaller square of side \(cut) cm removed from one corner. What is the remaining area?"
            let choices = shuffledOptions(correct: remainingArea, spread: max(4, difficulty * 2))
            return makeQuestion(prompt: prompt, answer: remainingArea, choices: choices, explanation: "Subtract the cut-out area.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Composite Area", part: .partB)
        }

        let angle = Int.random(in: 25...70)
        let supplementary = 180 - angle
        let prompt = "Two parallel lines are cut by a transversal. If one interior angle is \(angle) degrees, what is its supplementary interior angle?"
        let choices = shuffledOptions(correct: supplementary, spread: max(8, difficulty * 2))
        return makeQuestion(prompt: prompt, answer: supplementary, choices: choices, explanation: "Supplementary angles add to 180.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Parallel Lines", part: .partB)
    }

    private func partCGeometry(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...7)
        if variant == 1 {
            let prompt = "Square ABCD is divided into four identical smaller squares, then into triangles as shown. What fraction of ABCD is shaded?"
            let choices = ["1/4", "15/32", "7/16", "3/8", "7/8"]
            let correctIndex = choices.firstIndex(of: "15/32") ?? 1
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Break into congruent triangles and add shaded pieces.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Shaded Area", part: .partC)
        }

        if variant == 2 {
            let sides = [5, 6, 8, 10, 12].randomElement() ?? 6
            let interior = (sides - 2) * 180 / sides
            let prompt = "Each interior angle of a regular polygon is \(interior) degrees. How many sides does it have?"
            var choices = ["4", "5", "6", "8", "10", "12"].shuffled()
            if !choices.prefix(5).contains(String(sides)) {
                choices[0] = String(sides)
            }
            return makeQuestion(prompt: prompt, answer: sides, choices: Array(choices.prefix(5)), explanation: "Solve (n-2)180/n = interior.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Regular Polygons", part: .partC)
        }

        if variant == 3 {
            let side = Int.random(in: 2...5)
            let rows = Int.random(in: 3...5)
            let cols = Int.random(in: 4...6)
            let fits = (rows * cols) / (side * side)
            let prompt = "A \(rows) by \(cols) grid of unit squares is tiled by \(side) by \(side) tiles. What is the greatest number of tiles that can fit?"
            let choices = shuffledOptions(correct: fits, minValue: 0, spread: max(3, difficulty / 2 + 2))
            return makeQuestion(prompt: prompt, answer: fits, choices: choices, explanation: "Use area bound and floor.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Packing", part: .partC)
        }

        if variant == 4 {
            let m = Int.random(in: 5...10)
            let n = Int.random(in: 5...10)
            let outer = 2 * m * n + m + n
            let inner = (m - 1) * (n - 1)
            let total = outer + inner
            let percent = Int((Double(inner) / Double(total) * 100.0).rounded())
            let prompt = "A \(m) by \(n) grid is made with toothpicks. To the nearest percent, what percent are inner toothpicks?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Inner = (m-1)(n-1).", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Grid Counting", part: .partC)
        }

        if variant == 5 {
            let edge = Int.random(in: 5...8)
            let answer = (edge - 2) * (edge - 2) * (edge - 2)
            let prompt = "A cube of edge length \(edge) is painted on all faces and cut into 1x1x1 cubes. How many cubes have no paint?"
            let choices = shuffledOptions(correct: answer, minValue: 0, spread: 8)
            return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Unpainted cubes are interior: (edge-2)^3.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Painted Cube", part: .partC)
        }

        if variant == 6 {
            let choices = ["29", "43", "66", "172", "65"]
            let prompt = "Each new figure is formed by adding two 10x5 rectangles below the previous one. If figure n has perimeter 710 cm, what is n?"
            let correctIndex = choices.firstIndex(of: "66") ?? 2
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Build a linear perimeter model in n.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Perimeter Sequence", part: .partC)
        }

        let choices = ["39", "38", "37", "36", "35"]
        let prompt = "A 12x12x12 cube is built from numbered unit cubes. For how many values of c < 100 is the maximum exterior sum between 80,000 and 85,000?"
        let correctIndex = choices.firstIndex(of: "38") ?? 1
        return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Count c values after deriving the exterior-sum expression.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "3D Exterior Sum", part: .partC)
    }

    private func partAAlgebra(difficulty: Int) -> GeneratedQuestion {
        let start = Int.random(in: 2...8)
        let step = Int.random(in: 2...6)
        let terms = [start, start + step, start + 2 * step, start + 3 * step]
        let answer = start + 4 * step
        let prompt = "Find the next term: \(terms[0]), \(terms[1]), \(terms[2]), \(terms[3]), ..."
        let choices = shuffledOptions(correct: answer, spread: max(4, difficulty))
        return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "This is an arithmetic pattern.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Sequences", part: .partA)
    }

    private func partBAlgebra(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let n = Int.random(in: 4...10)
            let expression = 3 * n - 2
            let prompt = "If n = \(n), what is 3n - 2?"
            let choices = shuffledOptions(correct: expression, spread: max(4, difficulty))
            return makeQuestion(prompt: prompt, answer: expression, choices: choices, explanation: "Substitute and evaluate.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Expressions", part: .partB)
        }

        let x = Int.random(in: 2...(8 + difficulty))
        let a = Int.random(in: 2...(6 + difficulty / 2))
        let b = Int.random(in: 2...(10 + difficulty))
        let c = a * x + b
        let prompt = "Solve for x: \(a)x + \(b) = \(c)"
        let choices = shuffledOptions(correct: x, spread: max(3, difficulty / 2 + 2))
        return makeQuestion(prompt: prompt, answer: x, choices: choices, explanation: "Isolate x by inverse operations.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Linear Equations", part: .partB)
    }

    private func partCAlgebra(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...4)
        if variant == 1 {
            let first = Int.random(in: 2...8)
            let diff = Int.random(in: 3...7)
            let n = Int.random(in: 15...(40 + difficulty))
            let value = first + (n - 1) * diff
            let prompt = "An arithmetic sequence starts at \(first) and increases by \(diff). What is the \(n)th term?"
            let choices = shuffledOptions(correct: value, spread: max(10, difficulty * 3))
            return makeQuestion(prompt: prompt, answer: value, choices: choices, explanation: "Use a_n = a_1 + (n-1)d.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Arithmetic Sequence", part: .partC)
        }

        if variant == 2 {
            let choices = ["15", "19", "20", "23", "26"]
            let prompt = "In p, q, r, s, t, u, v, w, each variable is a positive integer. Every 4 consecutive terms sum to 35. If q + v = 14, what is the largest possible p?"
            let correctIndex = choices.firstIndex(of: "23") ?? 3
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Set equal consecutive-window sums and use positivity.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Constraint Maximization", part: .partC)
        }

        if variant == 3 {
            let n = Int.random(in: 8...15)
            let sum = (1...n).reduce(0) { $0 + $1 * $1 + $1 }
            let prompt = "The nth term of a sequence is n^2 + n. What is the sum of the first \(n) terms?"
            let choices = shuffledOptions(correct: sum, spread: max(20, n * 2))
            return makeQuestion(prompt: prompt, answer: sum, choices: choices, explanation: "Evaluate and sum the first n terms.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Sequence Sums", part: .partC)
        }

        let n = Int.random(in: 12...(40 + difficulty * 2))
        let ruleA = Int.random(in: 2...5)
        let ruleB = Int.random(in: 1...9)
        let value = ruleA * n + ruleB
        let prompt = "A pattern is defined by T(n) = \(ruleA)n + \(ruleB). What is T(\(n))?"
        let choices = shuffledOptions(correct: value, spread: max(12, difficulty * 2))
        return makeQuestion(prompt: prompt, answer: value, choices: choices, explanation: "Substitute n into the rule.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Modeling", part: .partC)
    }

    private func partAData(difficulty: Int) -> GeneratedQuestion {
        let values = (0..<5).map { _ in Int.random(in: 2...(12 + difficulty)) }
        let mean = values.reduce(0, +) / values.count
        let prompt = "Find the mean of: \(values.map(String.init).joined(separator: ", "))."
        let choices = shuffledOptions(correct: mean, spread: max(4, difficulty))
        return makeQuestion(prompt: prompt, answer: mean, choices: choices, explanation: "Mean = total divided by number of values.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Mean", part: .partA)
    }

    private func partBData(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let x = Int.random(in: 4...14)
            let y = Int.random(in: 8...18)
            let z = Int.random(in: 10...22)
            let mean = (x + y + z) / 3
            let prompt = "The three test scores are \(x), \(y), and \(z). What is their mean?"
            let choices = shuffledOptions(correct: mean, spread: max(3, difficulty))
            return makeQuestion(prompt: prompt, answer: mean, choices: choices, explanation: "Add and divide by 3.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Mean", part: .partB)
        }

        let red = Int.random(in: 2...(7 + difficulty / 2))
        let blue = Int.random(in: 2...(7 + difficulty / 2))
        let green = Int.random(in: 2...(7 + difficulty / 2))
        let total = red + blue + green
        let percentBlue = Int((Double(blue) / Double(total) * 100.0).rounded())
        let prompt = "A bag has \(red) red, \(blue) blue, and \(green) green marbles. What is the probability (as a percent) of drawing a blue marble?"
        let choices = shuffledOptions(correct: percentBlue, minValue: 0, spread: max(8, difficulty * 2)).map { "\($0)%" }
        let correctIndex = choices.firstIndex(of: "\(percentBlue)%") ?? 0
        return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Probability = favorable over total.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Basic Probability", part: .partB)
    }

    private func partCData(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...7)
        if variant == 1 {
            let red = Int.random(in: 3...7)
            let blue = Int.random(in: 3...7)
            let green = Int.random(in: 3...7)
            let total = red + blue + green
            let sameColorWays = red * (red - 1) + blue * (blue - 1) + green * (green - 1)
            let totalWays = total * (total - 1)
            let percent = Int((Double(sameColorWays) / Double(totalWays) * 100.0).rounded())
            let prompt = "A bag has \(red) red, \(blue) blue, and \(green) green marbles. Two are drawn without replacement. What is the probability (as a percent) both are the same color?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Count same-color ordered draws over all ordered draws.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Advanced Probability", part: .partC)
        }

        if variant == 2 {
            let answer = "6/25"
            let prompt = "After random exchanges between Arjun's and Becca's bags, what is the probability that each bag ends with exactly 3 different colors?"
            let choices = ["3/10", "6/25", "9/50", "3/25", "9/25"]
            let correctIndex = choices.firstIndex(of: answer) ?? 1
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Enumerate exchange branches and favorable outcomes.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Multi-step Probability", part: .partC)
        }

        if variant == 3 {
            let prompt = "L, M, N, O, P, Q, R, S are arranged on a circle. Starting with L, write every third letter not yet written. What order appears?"
            let choices = ["L O R N S Q M P", "L Q O M S R N P", "L R O M S Q N P", "L M N O P Q R S", "L O R M Q P N S"]
            let correctIndex = choices.firstIndex(of: "L R O M S Q N P") ?? 2
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Simulate clockwise skipping of already-used letters.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Circular Logic", part: .partC)
        }

        if variant == 4 {
            let pool = ["95", "175", "185", "191", "261"]
            let answer = "261"
            let prompt = "In a 3-set attendance Venn puzzle with no one in fewer than two sets, what is the sum of all possible values of k?"
            var choices = pool.shuffled()
            if !choices.contains(answer) {
                choices[0] = answer
            }
            let correctIndex = choices.firstIndex(of: answer) ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Convert percentage constraints to overlap equations.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Venn and Logic", part: .partC)
        }

        if variant == 5 {
            let answer = 14
            let prompt = "A circle is split into 6 equal sectors, colored with 3 red, 1 blue, 1 green, 1 yellow. How many distinct colorings are there up to rotation?"
            let choices = shuffledOptions(correct: answer, spread: 6)
            return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Use rotational symmetry counting.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Coloring and Symmetry", part: .partC)
        }

        if variant == 6 {
            let values = (0..<7).map { _ in Int.random(in: 5...(25 + difficulty * 2)) }.sorted()
            let median = values[values.count / 2]
            let prompt = "The sorted data set is \(values.map(String.init).joined(separator: ", ")). What is the median?"
            let choices = shuffledOptions(correct: median, spread: max(5, difficulty))
            return makeQuestion(prompt: prompt, answer: median, choices: choices, explanation: "With 7 values, the median is the 4th value.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Median", part: .partC)
        }

        let r1 = 1
        let r2 = 5
        let x = 8
        let prompt = "Three circles have radii 1 cm, 5 cm, and x cm. If their mean area is 30pi cm^2, what is x?"
        let choices = shuffledOptions(correct: x, spread: 8)
        return makeQuestion(prompt: prompt, answer: x, choices: choices, explanation: "(1^2 + 5^2 + x^2)/3 = 30 gives x^2 = 64.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Mean with Geometry", part: .partC)
    }

    private func makeQuestion(
        prompt: String,
        answer: Int,
        choices: [String],
        explanation: String,
        difficulty: Int,
        topic: Topic,
        subtopic: String,
        part: GaussPart
    ) -> GeneratedQuestion {
        let correctIndex = choices.firstIndex(of: String(answer)) ?? 0
        return GeneratedQuestion(
            prompt: prompt,
            choices: choices,
            correctIndex: correctIndex,
            explanation: explanation,
            difficulty: difficulty,
            topic: topic,
            subtopic: subtopic,
            part: part
        )
    }

    private func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        var x = abs(a)
        var y = abs(b)
        while y != 0 {
            let t = y
            y = x % y
            x = t
        }
        return x
    }

    private func leastCommonMultiple(_ a: Int, _ b: Int) -> Int {
        return abs(a * b) / greatestCommonDivisor(a, b)
    }

    private func shuffledOptions(correct: Int, minValue: Int = 1, spread: Int) -> [String] {
        var values = Set<Int>()
        values.insert(correct)

        while values.count < 5 {
            let offset = Int.random(in: -spread...spread)
            let candidate = max(minValue, correct + offset)
            values.insert(candidate)
        }

        return values.map(String.init).shuffled()
    }
}
