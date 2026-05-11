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
            // 5-digit palindromes abcba with even a and 2a+2b+c ≡ 0 mod 9.
            // For each even a ∈ {2,4,6,8}: exactly 11 valid (b,c) pairs. Total = 4×11 = 44.
            let count = 44
            let prompt = "How many palindromes greater than 10,000 and less than 100,000 are multiples of 18?"
            let choices = ["41", "42", "43", "44", "45"].shuffled()
            let correctIndex = choices.firstIndex(of: "44") ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "A 5-digit palindrome has form abcba. Divisible by 18 requires a even (last digit even) and digit sum 2a+2b+c divisible by 9. For each of 4 even values of a, there are exactly 11 valid (b,c) pairs, giving 4×11 = 44.", difficulty: difficulty, topic: .numberSenseNumeration, subtopic: "Palindromes and Divisibility", part: .partC)
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
            let n = Int.random(in: 4...8)
            let answer = fibonacci(n + 1)
            let prompt = "In how many ways can a 2 × \(n) rectangle be tiled completely using 1 × 2 dominoes?"
            let choices = shuffledOptions(correct: answer, minValue: 1, spread: max(8, answer / 2))
            return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Let T(k) be the count. T(1)=1, T(2)=2, and T(k)=T(k-1)+T(k-2). So T(\(n))=\(answer).", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Domino Tiling", part: .partC)
        }

        if variant == 2 {
            let sides = [6, 7, 8, 9, 10].randomElement() ?? 8
            let angleSum = (sides - 2) * 180
            let diagonals = sides * (sides - 3) / 2
            let prompt = "The interior angles of a convex polygon sum to \(angleSum) degrees. How many diagonals does the polygon have?"
            let choices = shuffledOptions(correct: diagonals, minValue: 0, spread: 8)
            return makeQuestion(prompt: prompt, answer: diagonals, choices: choices, explanation: "Find n from (n-2)×180 = \(angleSum) to get n=\(sides), then diagonals = n(n-3)/2 = \(diagonals).", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Polygon Diagonals", part: .partC)
        }

        if variant == 3 {
            // Doghouse leash problem (2021G8 Q23 style).
            // Dog on leash length L attached to corner of square doghouse side s, with s < L < 2s.
            // Area = (3/4)πL² + 2×(1/4)π(L-s)² = π × (3L²/4 + (L-s)²/2).
            // Pre-computed pairs (L, s, π-coefficient) where coefficient is an integer:
            let pairs = [(4, 2, 14), (6, 4, 29), (8, 6, 50), (10, 8, 77), (12, 10, 110)]
            let (L, s, coeff) = pairs.randomElement()!
            let prompt = "A dog's leash of length \(L) m is attached to a corner of a square doghouse with side \(s) m. What is the area (in multiples of π m²) outside the doghouse where the dog can roam?"
            let correctStr = "\(coeff)π"
            var wrongCoeffs = Set<Int>()
            while wrongCoeffs.count < 4 {
                let offset = Int.random(in: -5...5)
                let candidate = coeff + offset * 2
                if candidate > 0 && candidate != coeff { wrongCoeffs.insert(candidate) }
            }
            var choices = wrongCoeffs.prefix(4).map { "\($0)π" } + [correctStr]
            choices.shuffle()
            let correctIndex = choices.firstIndex(of: correctStr) ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Main arc (270°): (3/4)π×\(L)² = \(3*L*L/4)π. Two corner arcs (each 90°): 2×(1/4)π×\(L-s)² = \((L-s)*(L-s)/2)π. Total = \(coeff)π m².", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Leash Area", part: .partC)
        }

        if variant == 4 {
            // Toothpick grid percent (2024G7 Q22 style).
            // For an m×n grid of squares:
            //   Total toothpicks = n(m+1) + m(n+1) = 2mn + m + n
            //   Inner toothpicks = n(m-1) + m(n-1) = 2mn - m - n
            let m = Int.random(in: 8...20)
            let n = Int.random(in: 8...20)
            let total = 2 * m * n + m + n
            let inner = 2 * m * n - m - n
            let percent = Int((Double(inner) / Double(total) * 100.0).rounded())
            let prompt = "Toothpicks form a \(m) × \(n) grid of unit squares. To the nearest percent, what percentage of the toothpicks are inner (not on the border)?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(prompt: prompt, choices: choices, correctIndex: correctIndex, explanation: "Total toothpicks = 2mn+m+n = \(total). Inner toothpicks = n(m-1)+m(n-1) = 2mn-m-n = \(inner). Percent = \(inner)/\(total) ≈ \(percent)%.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Grid Toothpick Count", part: .partC)
        }

        if variant == 5 {
            let edge = Int.random(in: 5...8)
            let answer = (edge - 2) * (edge - 2) * (edge - 2)
            let prompt = "A cube of edge length \(edge) is painted on all faces and cut into 1x1x1 cubes. How many cubes have no paint?"
            let choices = shuffledOptions(correct: answer, minValue: 0, spread: 8)
            return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Unpainted cubes are interior: (edge-2)^3.", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Painted Cube", part: .partC)
        }

        if variant == 6 {
            let pythagorean = [(14, 5, 12), (28, 10, 48), (34, 13, 60), (42, 15, 108), (46, 17, 120)].randomElement()!
            let (perimeter, diagonal, area) = pythagorean
            let prompt = "A rectangle has perimeter \(perimeter) cm and diagonal \(diagonal) cm. What is its area in cm²?"
            let choices = shuffledOptions(correct: area, minValue: 1, spread: max(12, area / 4))
            return makeQuestion(prompt: prompt, answer: area, choices: choices, explanation: "Use l+w = P/2 and Area = ((P/2)² − D²)/2 = (\(perimeter/2)² − \(diagonal)²)/2 = \(area) cm².", difficulty: difficulty, topic: .geometrySpatialSense, subtopic: "Rectangle from Perimeter and Diagonal", part: .partC)
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
            let diff = Int.random(in: 2...5)
            let n = Int.random(in: 8...20)
            let sum = n * (2 * first + (n - 1) * diff) / 2
            let prompt = "An arithmetic sequence has first term \(first) and common difference \(diff). The sum of the first n terms is \(sum). Find n."
            let choices = shuffledOptions(correct: n, minValue: 1, spread: 6)
            return makeQuestion(prompt: prompt, answer: n, choices: choices, explanation: "Use S_n = n/2 × (2a + (n−1)d) = \(sum) and solve the resulting quadratic for n.", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Sum of Arithmetic Sequence", part: .partC)
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

        let qa = Int.random(in: 1...2)
        let qb = Int.random(in: 1...4)
        let qc = Int.random(in: 0...3)
        let t1 = qa + qb + qc
        let t2 = 4 * qa + 2 * qb + qc
        let t3 = 9 * qa + 3 * qb + qc
        let k = Int.random(in: 6...12)
        let answer = qa * k * k + qb * k + qc
        let prompt = "A quadratic pattern gives T(1) = \(t1), T(2) = \(t2), T(3) = \(t3). Find T(\(k))."
        let choices = shuffledOptions(correct: answer, spread: max(15, difficulty * 3))
        return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Set T(n) = an² + bn + c, solve for a, b, c using T(1), T(2), T(3), then evaluate T(\(k)) = \(answer).", difficulty: difficulty, topic: .algebraPatterning, subtopic: "Quadratic Pattern", part: .partC)
    }

    private func partAData(difficulty: Int) -> GeneratedQuestion {
        let values = (0..<5).map { _ in Int.random(in: 2...(12 + difficulty)) }
        let mean = values.reduce(0, +) / values.count
        let prompt = "Find the mean of: \(values.map(String.init).joined(separator: ", "))."
        let choices = shuffledOptions(correct: mean, spread: max(4, difficulty))
        return makeQuestion(prompt: prompt, answer: mean, choices: choices, explanation: "Mean = total divided by number of values.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Mean", part: .partA)
    }

    private func partBData(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...6)
        if variant == 1 {
            let x = Int.random(in: 4...14)
            let y = Int.random(in: 8...18)
            let z = Int.random(in: 10...22)
            let mean = (x + y + z) / 3
            let prompt = "The three test scores are \(x), \(y), and \(z). What is their mean?"
            let choices = shuffledOptions(correct: mean, spread: max(3, difficulty))
            return makeQuestion(prompt: prompt, answer: mean, choices: choices, explanation: "Add and divide by 3.", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Mean", part: .partB)
        }

        if variant == 2 {
            let distances = [
                Int.random(in: 2...5),
                Int.random(in: 6...10),
                Int.random(in: 9...14),
                Int.random(in: 12...18)
            ]
            let points = distances.enumerated().map { index, value in
                GraphPoint(x: Double(index), y: Double(value))
            }
            let increases = [
                distances[1] - distances[0],
                distances[2] - distances[1],
                distances[3] - distances[2]
            ]
            let maxIncrease = increases.max() ?? 0
            let correctIntervalIndex = increases.firstIndex(of: maxIncrease) ?? 0
            let intervals = ["0-1", "1-2", "2-3"]
            let answer = intervals[correctIntervalIndex]
            let prompt = "The line graph shows distance from home (km) over time (hours). During which interval was the increase greatest?"
            let choices = ["0-1", "1-2", "2-3", "All equal", "Cannot be determined"]
            let correctIndex = choices.firstIndex(of: answer) ?? 0
            let graph = QuestionGraph(
                style: .line,
                points: points,
                xLabel: "Time (hours)",
                yLabel: "Distance (km)",
                title: "Distance-Time Graph"
            )
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Compare vertical increases between consecutive points.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Graph Interpretation",
                part: .partB,
                graph: graph
            )
        }

        if variant == 3 {
            let a = Int.random(in: 4...9)
            let b = Int.random(in: 6...12)
            let c = Int.random(in: 5...11)
            let d = Int.random(in: 7...13)
            let values = [a, b, c, d]
            let points = values.enumerated().map { idx, value in
                GraphPoint(x: Double(idx), y: Double(value))
            }
            let total = values.reduce(0, +)
            let prompt = "The bar graph shows books read by four students in a month. How many books were read in total?"
            let choices = shuffledOptions(correct: total, minValue: 1, spread: 8)
            let graph = QuestionGraph(
                style: .bar,
                points: points,
                xLabel: "Students A-D",
                yLabel: "Books",
                title: "Books Read"
            )
            return makeQuestion(
                prompt: prompt,
                answer: total,
                choices: choices,
                explanation: "Add all bar heights.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Bar Graph: Total",
                part: .partB,
                graph: graph
            )
        }

        if variant == 4 {
            let values = [
                Int.random(in: 10...18),
                Int.random(in: 12...20),
                Int.random(in: 8...16),
                Int.random(in: 14...22),
                Int.random(in: 11...19)
            ]
            let points = values.enumerated().map { idx, value in
                GraphPoint(x: Double(idx), y: Double(value))
            }
            let maxValue = values.max() ?? 0
            let minValue = values.min() ?? 0
            let range = maxValue - minValue
            let prompt = "The bar graph shows daily temperatures over 5 days. What is the range of the temperatures?"
            let choices = shuffledOptions(correct: range, minValue: 0, spread: 6)
            let graph = QuestionGraph(
                style: .bar,
                points: points,
                xLabel: "Day 1-5",
                yLabel: "Temperature",
                title: "Daily Temperatures"
            )
            return makeQuestion(
                prompt: prompt,
                answer: range,
                choices: choices,
                explanation: "Range = maximum value - minimum value.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Bar Graph: Range",
                part: .partB,
                graph: graph
            )
        }

        if variant == 5 {
            let values = [
                Int.random(in: 3...6),
                Int.random(in: 7...11),
                Int.random(in: 5...9),
                Int.random(in: 10...14),
                Int.random(in: 8...12)
            ]
            let points = values.enumerated().map { idx, value in
                GraphPoint(x: Double(idx), y: Double(value))
            }
            let peak = values.max() ?? 0
            let peakIndex = values.firstIndex(of: peak) ?? 0
            let answer = String(peakIndex + 1)
            let prompt = "The line graph shows points scored in 5 rounds. In which round was the score highest?"
            let choices = ["1", "2", "3", "4", "5"]
            let correctIndex = choices.firstIndex(of: answer) ?? 0
            let graph = QuestionGraph(
                style: .line,
                points: points,
                xLabel: "Round",
                yLabel: "Points",
                title: "Round Scores"
            )
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Pick the round with the highest plotted point.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Line Graph: Maximum",
                part: .partB,
                graph: graph
            )
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
            let total = Int.random(in: 6...9)
            let totalWays = combination(total, 3)
            let withBoth = total - 2
            let answer = totalWays - withBoth
            let prompt = "From \(total) students, a team of 3 is chosen. Two specific students refuse to be on the same team. How many valid teams are there?"
            let choices = shuffledOptions(correct: answer, minValue: 1, spread: max(6, difficulty))
            return makeQuestion(prompt: prompt, answer: answer, choices: choices, explanation: "Total ways: C(\(total),3) = \(totalWays). Teams including both: \(total)−2 = \(withBoth). Valid teams: \(totalWays)−\(withBoth) = \(answer).", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Combinatorics with Restrictions", part: .partC)
        }

        // Committee counting with restriction (2022G8 Q24 style).
        let boys = Int.random(in: 2...4)
        let girls = Int.random(in: 3...5)
        let size = boys + 1 // committee size
        // Count committees of 'size' from (boys+girls) people with AT LEAST 2 girls.
        let total_people = boys + girls
        var validCommittees = 0
        for g in 2...min(size, girls) {
            let b = size - g
            if b <= boys {
                validCommittees += combination(girls, g) * combination(boys, b)
            }
        }
        let totalCommittees = combination(total_people, size)
        let prompt = "From a group of \(boys) boys and \(girls) girls, a committee of \(size) people is chosen at random. How many different committees include at least 2 girls?"
        let choices = shuffledOptions(correct: validCommittees, minValue: 1, spread: max(5, validCommittees / 3))
        return makeQuestion(prompt: prompt, answer: validCommittees, choices: choices, explanation: "Sum C(\(girls),g)×C(\(boys),\(size)-g) for g=2 to \(min(size,girls)). Total with at least 2 girls = \(validCommittees) (out of C(\(total_people),\(size))=\(totalCommittees)).", difficulty: difficulty, topic: .dataManagementProbability, subtopic: "Committee Counting", part: .partC)
    }

    private func makeQuestion(
        prompt: String,
        answer: Int,
        choices: [String],
        explanation: String,
        difficulty: Int,
        topic: Topic,
        subtopic: String,
        part: GaussPart,
        graph: QuestionGraph? = nil
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
            part: part,
            graph: graph
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

    private func fibonacci(_ n: Int) -> Int {
        guard n > 0 else { return 0 }
        if n == 1 { return 1 }
        var a = 1, b = 1
        for _ in 3...n {
            let c = a + b
            a = b
            b = c
        }
        return b
    }

    private func combination(_ n: Int, _ r: Int) -> Int {
        guard r >= 0, r <= n else { return 0 }
        var result = 1
        for i in 0..<r {
            result = result * (n - i) / (i + 1)
        }
        return result
    }
}
