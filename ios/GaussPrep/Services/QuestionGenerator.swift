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
        // Approximate Gauss-style emphasis: more Number Sense in early parts,
        // more mixed/puzzle-like distribution in later parts.
        let r = Int.random(in: 1...100)

        switch part {
        case .partA:
            if r <= 45 { return .numberSenseNumeration }
            if r <= 70 { return .geometrySpatialSense }
            if r <= 90 { return .algebraPatterning }
            return .dataManagementProbability
        case .partB:
            if r <= 35 { return .numberSenseNumeration }
            if r <= 62 { return .geometrySpatialSense }
            if r <= 85 { return .algebraPatterning }
            return .dataManagementProbability
        case .partC:
            if r <= 28 { return .numberSenseNumeration }
            if r <= 55 { return .geometrySpatialSense }
            if r <= 80 { return .algebraPatterning }
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
        if Bool.random() {
            let percent = [10, 20, 25, 50].randomElement() ?? 25
            let base = Int.random(in: 40...(160 + difficulty * 20))
            let value = base * percent / 100
            let prompt = "What is \(percent)% of \(base)?"
            let choices = shuffledOptions(correct: value, spread: max(6, difficulty * 2))
            return makeQuestion(
                prompt: prompt,
                answer: value,
                choices: choices,
                explanation: "Convert percent to fraction: \(percent)% = \(percent)/100. Then compute \(percent)/100 x \(base) = \(value).",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Fractions, Decimals, Percentages, Ratios",
                part: .partA
            )
        }

        let value = Int.random(in: 100...(400 + difficulty * 40))
        let divisor = [2, 3, 5, 9, 10].randomElement() ?? 2
        let isDivisible = value % divisor == 0
        let prompt = "Which statement is true about \(value)?"
        let choices = [
            "It is divisible by \(divisor)",
            "It is not divisible by \(divisor)",
            "Its greatest common divisor with \(divisor) is \(divisor + 1)",
            "Its remainder when divided by \(divisor) is \(divisor)",
            "It is a multiple of \(divisor + 2)"
        ]
        let correctIndex = isDivisible ? 0 : 1
        return GeneratedQuestion(
            prompt: prompt,
            choices: choices,
            correctIndex: correctIndex,
            explanation: "Use divisibility rules or direct division. \(value) is \(isDivisible ? "" : "not ")divisible by \(divisor).",
            difficulty: difficulty,
            topic: .numberSenseNumeration,
            subtopic: "Number Theory: Divisibility",
            part: .partA
        )
    }

    private func partBNumberSense(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let n = Int.random(in: 180...(420 + difficulty * 15))
            let prompt = "How many trailing zeros are in \(n) x 25 x 8?"
            let product = n * 25 * 8
            let zeros = String(product).reversed().prefix { $0 == "0" }.count
            let choices = shuffledOptions(correct: zeros, minValue: 0, spread: 2)
            return makeQuestion(
                prompt: prompt,
                answer: zeros,
                choices: choices,
                explanation: "A trailing zero comes from a factor of 10 = 2 x 5. Count the number of matched 2s and 5s in the product.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Number Theory: Prime Factors",
                part: .partB
            )
        }

        let a = Int.random(in: 8...(20 + difficulty))
        let b = Int.random(in: 6...(18 + difficulty))
        let lcm = leastCommonMultiple(a, b)
        let prompt = "A bell rings every \(a) minutes and another rings every \(b) minutes. If they ring together now, after how many minutes will they ring together again?"
        let choices = shuffledOptions(correct: lcm, spread: max(8, difficulty * 2))
        return makeQuestion(
            prompt: prompt,
            answer: lcm,
            choices: choices,
            explanation: "This is an LCM problem. LCM(\(a), \(b)) = \(lcm).",
            difficulty: difficulty,
            topic: .numberSenseNumeration,
            subtopic: "Number Theory: LCM/GCD",
            part: .partB
        )
    }

    private func partCNumberSense(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let a = Int.random(in: 11...19)
            let b = Int.random(in: 11...19)
            let c = Int.random(in: 11...19)
            let value = a * b * c
            let mod = Int.random(in: 6...12)
            let remainder = value % mod
            let prompt = "What is the remainder when \(a) x \(b) x \(c) is divided by \(mod)?"
            let choices = shuffledOptions(correct: remainder, minValue: 0, spread: 3)
            return makeQuestion(
                prompt: prompt,
                answer: remainder,
                choices: choices,
                explanation: "You can reduce factors modulo \(mod) before multiplying to simplify.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Number Theory: Modular Arithmetic",
                part: .partC
            )
        }

        let amount = Int.random(in: 45...(120 + difficulty * 5))
        let discount = [10, 15, 20, 25].randomElement() ?? 15
        let tax = [5, 8, 10, 13].randomElement() ?? 13
        let discounted = Double(amount) * (1.0 - Double(discount) / 100.0)
        let total = Int((discounted * (1.0 + Double(tax) / 100.0)).rounded())
        let prompt = "A game costs $\(amount). It is discounted by \(discount)% and then taxed at \(tax)%. What is the final price, to the nearest dollar?"
        let choices = shuffledOptions(correct: total, spread: max(8, difficulty * 3))
        return makeQuestion(
            prompt: prompt,
            answer: total,
            choices: choices,
            explanation: "Apply discount first, then tax: \(amount) x (1 - \(discount)/100) x (1 + \(tax)/100), then round.",
            difficulty: difficulty,
            topic: .numberSenseNumeration,
            subtopic: "Money & Measurement",
            part: .partC
        )
    }

    private func partAGeometry(difficulty: Int) -> GeneratedQuestion {
        let width = Int.random(in: 3...(9 + difficulty))
        let length = Int.random(in: (width + 1)...(width + 8))
        let area = width * length
        let prompt = "What is the area of a rectangle with width \(width) cm and length \(length) cm?"
        let choices = shuffledOptions(correct: area, spread: max(6, difficulty * 2))
        return makeQuestion(
            prompt: prompt,
            answer: area,
            choices: choices,
            explanation: "Area = width x length = \(width) x \(length) = \(area).",
            difficulty: difficulty,
            topic: .geometrySpatialSense,
            subtopic: "Area and Perimeter",
            part: .partA
        )
    }

    private func partBGeometry(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let side = Int.random(in: 4...9)
            let cut = Int.random(in: 1...(side - 1))
            let remainingArea = side * side - cut * cut
            let prompt = "A square of side \(side) cm has a smaller square of side \(cut) cm removed from one corner. What is the remaining area?"
            let choices = shuffledOptions(correct: remainingArea, spread: max(4, difficulty * 2))
            return makeQuestion(
                prompt: prompt,
                answer: remainingArea,
                choices: choices,
                explanation: "Subtract areas: \(side)^2 - \(cut)^2 = \(remainingArea).",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Composite Area",
                part: .partB
            )
        }

        let angle = Int.random(in: 25...70)
        let supplementary = 180 - angle
        let prompt = "Two parallel lines are cut by a transversal. If one interior angle is \(angle) degrees, what is its supplementary interior angle?"
        let choices = shuffledOptions(correct: supplementary, spread: max(8, difficulty * 2))
        return makeQuestion(
            prompt: prompt,
            answer: supplementary,
            choices: choices,
            explanation: "Interior angles on a straight line sum to 180 degrees, so 180 - \(angle) = \(supplementary).",
            difficulty: difficulty,
            topic: .geometrySpatialSense,
            subtopic: "Angles and Parallel Lines",
            part: .partB
        )
    }

    private func partCGeometry(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let sides = [5, 6, 8, 10, 12].randomElement() ?? 6
            let interior = (sides - 2) * 180 / sides
            let prompt = "Each interior angle of a regular polygon is \(interior) degrees. How many sides does the polygon have?"
            let choices = [4, 5, 6, 8, 10, 12]
                .shuffled()
                .prefix(5)
                .map(String.init)
            var finalChoices = choices
            if !finalChoices.contains(String(sides)) {
                finalChoices[0] = String(sides)
                finalChoices.shuffle()
            }
            return makeQuestion(
                prompt: prompt,
                answer: sides,
                choices: finalChoices,
                explanation: "Use interior angle formula: (n-2)180/n = \(interior), then solve for n.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Angles in Polygons",
                part: .partC
            )
        }

        let side = Int.random(in: 2...5)
        let rows = Int.random(in: 3...5)
        let cols = Int.random(in: 4...6)
        let fits = (rows * cols) / (side * side)
        let prompt = "A \(rows) by \(cols) grid of unit squares is tiled by \(side) by \(side) square tiles without overlap. What is the greatest number of such tiles that can fit?"
        let choices = shuffledOptions(correct: fits, minValue: 0, spread: max(3, difficulty / 2 + 2))
        return makeQuestion(
            prompt: prompt,
            answer: fits,
            choices: choices,
            explanation: "Each tile covers \(side * side) unit squares. The grid has \(rows * cols) unit squares, so at most floor(\(rows * cols)/\(side * side)) = \(fits).",
            difficulty: difficulty,
            topic: .geometrySpatialSense,
            subtopic: "Spatial Puzzle / Packing",
            part: .partC
        )
    }

    private func partAAlgebra(difficulty: Int) -> GeneratedQuestion {
        let start = Int.random(in: 2...8)
        let step = Int.random(in: 2...6)
        let terms = [start, start + step, start + 2 * step, start + 3 * step]
        let answer = start + 4 * step
        let prompt = "Find the next term: \(terms[0]), \(terms[1]), \(terms[2]), \(terms[3]), ..."
        let choices = shuffledOptions(correct: answer, spread: max(4, difficulty))
        return makeQuestion(
            prompt: prompt,
            answer: answer,
            choices: choices,
            explanation: "The pattern adds \(step) each time, so the next term is \(answer).",
            difficulty: difficulty,
            topic: .algebraPatterning,
            subtopic: "Sequences",
            part: .partA
        )
    }

    private func partBAlgebra(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let n = Int.random(in: 4...10)
            let expression = 3 * n - 2
            let prompt = "If n = \(n), what is 3n - 2?"
            let choices = shuffledOptions(correct: expression, spread: max(4, difficulty))
            return makeQuestion(
                prompt: prompt,
                answer: expression,
                choices: choices,
                explanation: "Substitute n = \(n) into the expression.",
                difficulty: difficulty,
                topic: .algebraPatterning,
                subtopic: "Modeling Expressions",
                part: .partB
            )
        }

        let x = Int.random(in: 2...(8 + difficulty))
        let a = Int.random(in: 2...(6 + difficulty / 2))
        let b = Int.random(in: 2...(10 + difficulty))
        let c = a * x + b
        let prompt = "Solve for x: \(a)x + \(b) = \(c)"
        let choices = shuffledOptions(correct: x, spread: max(3, difficulty / 2 + 2))
        return makeQuestion(
            prompt: prompt,
            answer: x,
            choices: choices,
            explanation: "Subtract \(b): \(a)x = \(c - b). Divide by \(a): x = \(x).",
            difficulty: difficulty,
            topic: .algebraPatterning,
            subtopic: "Solving for x",
            part: .partB
        )
    }

    private func partCAlgebra(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let first = Int.random(in: 2...8)
            let diff = Int.random(in: 3...7)
            let n = Int.random(in: 15...(40 + difficulty))
            let value = first + (n - 1) * diff
            let prompt = "An arithmetic sequence starts at \(first) and increases by \(diff). What is the \(n)th term?"
            let choices = shuffledOptions(correct: value, spread: max(10, difficulty * 3))
            return makeQuestion(
                prompt: prompt,
                answer: value,
                choices: choices,
                explanation: "Use a_n = a_1 + (n-1)d.",
                difficulty: difficulty,
                topic: .algebraPatterning,
                subtopic: "Nth Term (Arithmetic Sequence)",
                part: .partC
            )
        }

        let n = Int.random(in: 12...(40 + difficulty * 2))
        let ruleA = Int.random(in: 2...5)
        let ruleB = Int.random(in: 1...9)
        let value = ruleA * n + ruleB
        let prompt = "A pattern is defined by T(n) = \(ruleA)n + \(ruleB). What is T(\(n))?"
        let choices = shuffledOptions(correct: value, spread: max(12, difficulty * 2))
        return makeQuestion(
            prompt: prompt,
            answer: value,
            choices: choices,
            explanation: "Substitute n = \(n): T(\(n)) = \(ruleA)(\(n)) + \(ruleB) = \(value).",
            difficulty: difficulty,
            topic: .algebraPatterning,
            subtopic: "Nth Term / Modeling",
            part: .partC
        )
    }

    private func partAData(difficulty: Int) -> GeneratedQuestion {
        let values = (0..<5).map { _ in Int.random(in: 2...(12 + difficulty)) }
        let mean = values.reduce(0, +) / values.count
        let prompt = "Find the mean of: \(values.map(String.init).joined(separator: ", "))."
        let choices = shuffledOptions(correct: mean, spread: max(4, difficulty))
        return makeQuestion(
            prompt: prompt,
            answer: mean,
            choices: choices,
            explanation: "Mean = sum of values / number of values.",
            difficulty: difficulty,
            topic: .dataManagementProbability,
            subtopic: "Statistics: Mean",
            part: .partA
        )
    }

    private func partBData(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let x = Int.random(in: 4...14)
            let y = Int.random(in: 8...18)
            let z = Int.random(in: 10...22)
            let mean = (x + y + z) / 3
            let prompt = "The three test scores are \(x), \(y), and \(z). What is their mean?"
            let choices = shuffledOptions(correct: mean, spread: max(3, difficulty))
            return makeQuestion(
                prompt: prompt,
                answer: mean,
                choices: choices,
                explanation: "Add and divide by 3.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Statistics: Mean",
                part: .partB
            )
        }

        let red = Int.random(in: 2...(7 + difficulty / 2))
        let blue = Int.random(in: 2...(7 + difficulty / 2))
        let green = Int.random(in: 2...(7 + difficulty / 2))
        let total = red + blue + green
        let percentBlue = Int((Double(blue) / Double(total) * 100.0).rounded())
        let prompt = "A bag has \(red) red, \(blue) blue, and \(green) green marbles. What is the probability (as a percent) of drawing a blue marble?"
        let choices = shuffledOptions(correct: percentBlue, minValue: 0, spread: max(8, difficulty * 2))
        let labeledChoices = choices.map { "\($0)%" }
        let correctIndex = labeledChoices.firstIndex(of: "\(percentBlue)%") ?? 0
        return GeneratedQuestion(
            prompt: prompt,
            choices: labeledChoices,
            correctIndex: correctIndex,
            explanation: "Probability = favorable/total = \(blue)/\(total), about \(percentBlue)%.",
            difficulty: difficulty,
            topic: .dataManagementProbability,
            subtopic: "Probability",
            part: .partB
        )
    }

    private func partCData(difficulty: Int) -> GeneratedQuestion {
        if Bool.random() {
            let red = Int.random(in: 3...8)
            let blue = Int.random(in: 3...8)
            let green = Int.random(in: 3...8)
            let total = red + blue + green
            let favorable = blue + green
            let percent = Int((Double(favorable) / Double(total) * 100.0).rounded())
            let prompt = "A jar has \(red) red, \(blue) blue, and \(green) green marbles. What is the probability (as a percent) of drawing a non-red marble?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Non-red means blue or green, so probability is (\(blue)+\(green))/\(total).",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Probability (Complement)",
                part: .partC
            )
        }

        var values = (0..<7).map { _ in Int.random(in: 5...(25 + difficulty * 2)) }.sorted()
        if values.count % 2 == 0 {
            values.append(Int.random(in: 5...(25 + difficulty * 2)))
            values.sort()
        }
        let median = values[values.count / 2]
        let prompt = "The sorted data set is \(values.map(String.init).joined(separator: ", ")). What is the median?"
        let choices = shuffledOptions(correct: median, spread: max(5, difficulty))
        return makeQuestion(
            prompt: prompt,
            answer: median,
            choices: choices,
            explanation: "With an odd number of values, the median is the middle value.",
            difficulty: difficulty,
            topic: .dataManagementProbability,
            subtopic: "Statistics: Median",
            part: .partC
        )
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
