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

    private func partCGeometry(difficulty: Int) -> GeneratedQuestion {
        let variant = Int.random(in: 1...6)
        if variant == 1 {
            // Shaded area in subdivided squares (like Q21)
            let prompt = "Square ABCD is divided into four identical smaller squares, which are further divided into triangles as shown. What fraction of ABCD is shaded?"
            let choices = ["1/4", "15/32", "7/16", "3/8", "7/8"]
            let correctIndex = 1 // 15/32
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Calculate the area of shaded triangles and sum as a fraction of the whole.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Shaded Area/Composite",
                part: .partC
            )
                } else if variant == 6 {
                    // Perimeter/sequence modeling (like Q22 rectangles)
                    let n = 66
                    let prompt = "Each figure after Figure 1 is formed by joining two rectangles to the bottom of the previous figure. Each rectangle is 10x5 cm. If Figure n has a perimeter of 710 cm, what is n?"
                    let choices = [29, 43, 66, 172, 65]
                    let correctIndex = choices.firstIndex(of: 66) ?? 2
                    return GeneratedQuestion(
                        prompt: prompt,
                        choices: choices.map { String($0) },
                        correctIndex: correctIndex,
                        explanation: "Model the perimeter sequence and solve for n.",
                        difficulty: difficulty,
                        topic: .geometrySpatialSense,
                        subtopic: "Perimeter/Sequence Modeling",
                        part: .partC
                    )
                } else if variant == 7 {
                    // 3D cube face sum with constraints (like Q25)
                    let answer = 38
                    let prompt = "Jonas has 1728 cubes with a net as shown, with c < 100. He builds a 12x12x12 cube so the sum on the exterior faces is as large as possible. For some c, the sum is between 80,000 and 85,000. How many such c are there?"
                    let choices = [39, 38, 37, 36, 35]
                    let correctIndex = choices.firstIndex(of: 38) ?? 1
                    return GeneratedQuestion(
                        prompt: prompt,
                        choices: choices.map { String($0) },
                        correctIndex: correctIndex,
                        explanation: "Count c values so the exterior sum is in the given range.",
                        difficulty: difficulty,
                        topic: .geometrySpatialSense,
                        subtopic: "3D Cube/Exterior Sum",
                        part: .partC
                    )
        } else if variant == 2 {
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
        } else if variant == 3 {
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
        } else if variant == 4 {
            // Toothpick grid: percent inner toothpicks
            let m = Int.random(in: 5...10)
            let n = Int.random(in: 5...10)
            let outer = 2 * m * n + m + n
            let inner = (m - 1) * (n - 1)
            let total = outer + inner
            let percent = Int((Double(inner) / Double(total) * 100.0).rounded())
            let prompt = "A \(m) by \(n) grid of squares is made with toothpicks. To the nearest percent, what percentage of toothpicks used are inner toothpicks?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Inner toothpicks = (m-1)(n-1), total = outer + inner.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Grid/Toothpick Reasoning",
                part: .partC
            )
        } else if variant == 5 {
            // Cube paint: mean possible V
            let edge = Int.random(in: 5...8)
            let painted = edge * edge * edge - (edge - 2) * (edge - 2) * (edge - 2)
            let prompt = "A cube of edge length \(edge) is painted on all faces and cut into 1x1x1 cubes. How many cubes have no paint on them?"
            let answer = (edge - 2) > 0 ? (edge - 2) * (edge - 2) * (edge - 2) : 0
            let choices = shuffledOptions(correct: answer, minValue: 0, spread: 8)
            return makeQuestion(
                prompt: prompt,
                answer: answer,
                choices: choices,
                explanation: "Unpainted cubes = (edge-2)^3.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Cube Paint/Interior Cubes",
                part: .partC
            )
        } else {
            // Tiny number: no rearrangement smaller
            var count = 0
            for n in 100...999 {
                let digits = String(n).compactMap { Int(String($0)) }
                let perms = Set([n,
                    digits[0]*100 + digits[2]*10 + digits[1],
                    digits[1]*100 + digits[0]*10 + digits[2],
                    digits[1]*100 + digits[2]*10 + digits[0],
                    digits[2]*100 + digits[0]*10 + digits[1],
                    digits[2]*100 + digits[1]*10 + digits[0]
                ])
                if perms.allSatisfy({ $0 >= n }) {
                    count += 1
                }
            }
            let prompt = "How many three-digit integers are Tiny (no rearrangement of its digits gives a smaller three-digit integer)?"
            let choices = shuffledOptions(correct: count, spread: 10)
            return makeQuestion(
                prompt: prompt,
                answer: count,
                choices: choices,
                explanation: "Check all permutations of digits; count if all ≥ n.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Digit Property/Tiny Number",
                part: .partC
            )
        }
    }
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
            // Two-step percent (e.g., percent of a sum)
            let a = Int.random(in: 20...(80 + difficulty * 10))
            let b = Int.random(in: 20...(80 + difficulty * 10))
            let percent = [10, 20, 25, 50].randomElement() ?? 25
            let sum = a + b
            let value = sum * percent / 100
            let prompt = "What is \(percent)% of (\(a) + \(b))?"
            let choices = shuffledOptions(correct: value, spread: max(6, difficulty * 2))
            return makeQuestion(
                prompt: prompt,
                answer: value,
    
            private func partCNumberSense(difficulty: Int) -> GeneratedQuestion {
                let variant = Int.random(in: 1...3)
                if variant == 1 {
                    // Number theory puzzle: smallest integer with given remainders
                    let a = Int.random(in: 2...5)
                    let b = Int.random(in: 6...9)
                    let r1 = Int.random(in: 1..<(a))
                    let r2 = Int.random(in: 1..<(b))
                    // Find smallest x: x ≡ r1 mod a, x ≡ r2 mod b
                    var x = r1
                    while x % b != r2 {
                        x += a
                    }
                    let prompt = "What is the smallest positive integer that leaves a remainder of \(r1) when divided by \(a), and a remainder of \(r2) when divided by \(b)?"
                    let choices = shuffledOptions(correct: x, spread: max(8, difficulty * 2))
                    return makeQuestion(
                        prompt: prompt,
                        answer: x,
                        choices: choices,
                        explanation: "Find x ≡ \(r1) mod \(a), x ≡ \(r2) mod \(b). Try x = \(r1), \(r1)+\(a), ... until x % \(b) = \(r2).",
                        difficulty: difficulty,
                        topic: .numberSenseNumeration,
                        subtopic: "Chinese Remainder/Modular Reasoning",
                        part: .partC
                    )
                } else if variant == 2 {
                    // Combinatorics: 4-digit numbers, all digits different, divisible by 5
                    var count = 0
                    for d1 in 1...9 {
                        for d2 in 0...9 where d2 != d1 {
                            for d3 in 0...9 where d3 != d1 && d3 != d2 {
                                for d4 in [0,5] where d4 != d1 && d4 != d2 && d4 != d3 {
                                    count += 1
                                }
                            }
                        }
                    }
                    let prompt = "How many 4-digit numbers have all digits different and are divisible by 5?"
                    let choices = shuffledOptions(correct: count, spread: 10)
                    return makeQuestion(
                        prompt: prompt,
                        answer: count,
                        choices: choices,
                        explanation: "Last digit 0 or 5, all digits different, first digit ≠ 0.",
                        difficulty: difficulty,
                        topic: .numberSenseNumeration,
                        subtopic: "Combinatorics: Counting",
                        part: .partC
                    )
                } else {
                    // Modular arithmetic (existing)
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
            }
                choices: choices,
                explanation: "First add: \(a)+\(b)=\(sum). Then \(percent)% of \(sum) = \(value).",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Percent of a Sum",
                part: .partA
            )
        } else if variant == 2 {
            // Small divisor puzzle (trap: remainder)
            let value = Int.random(in: 100...(400 + difficulty * 40))
            let divisor = [3, 4, 6, 7, 8].randomElement() ?? 3
            let remainder = value % divisor
            let prompt = "What is the remainder when \(value) is divided by \(divisor)?"
            let choices = shuffledOptions(correct: remainder, minValue: 0, spread: max(3, difficulty))
            return makeQuestion(
                prompt: prompt,
                answer: remainder,
                choices: choices,
                explanation: "Divide \(value) by \(divisor): remainder is \(remainder).",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Division Remainder",
                part: .partA
            )
        } else {
            // Multi-step: Find a number given area and perimeter
            let width = Int.random(in: 3...(9 + difficulty))
            let length = Int.random(in: (width + 1)...(width + 8))
            let area = width * length
            let perimeter = 2 * (width + length)
            let prompt = "A rectangle has area \(area) cm² and perimeter \(perimeter) cm. What is its width?"
            let choices = shuffledOptions(correct: width, spread: max(4, difficulty))
            return makeQuestion(
                prompt: prompt,
                answer: width,
                choices: choices,
                explanation: "Let width = w, length = l. Area = w*l, perimeter = 2(w+l). Solve for w.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Area & Perimeter Reasoning",
                part: .partA
            )
        }
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
        let variant = Int.random(in: 1...3)
        if variant == 1 {
            // Gauss-style: which angle does NOT belong in a quadrilateral
            // Pick 4 random angles that sum to 360, add 1 outlier
            var baseAngles = (0..<4).map { _ in Int.random(in: 60...120) }
            let sum = baseAngles.reduce(0, +)
            // Adjust last so sum is exactly 360
            baseAngles[3] += (360 - sum)
            // Outlier: pick a value not possible (e.g., 10-40° away from a real one)
            let outlier = baseAngles.randomElement()! + [18, 22, -18, -22].randomElement()!
            var allAngles = baseAngles + [outlier]
            allAngles.shuffle()
            let correct = outlier
            let prompt = "Four of the angle measurements \(allAngles.map { "\($0)°" }.joined(separator: ", ")) are the angles of the same quadrilateral. Which angle measure is NOT?"
            let choices = allAngles.map { "\($0)°" }
            let correctIndex = choices.firstIndex(of: "\(correct)°") ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Angles in a quadrilateral must sum to 360°. The outlier cannot fit with the others.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Quadrilateral Angle Reasoning",
                part: .partB
            )
        } else if variant == 2 {
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
        } else {
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
        let variant = Int.random(in: 1...13)
        if variant == 1 {
            // Advanced probability: two drawn, same color
            let red = Int.random(in: 3...7)
            let blue = Int.random(in: 3...7)
            let green = Int.random(in: 3...7)
            let total = red + blue + green
            let totalWays = total * (total - 1)
            let sameColorWays = red * (red - 1) + blue * (blue - 1) + green * (green - 1)
            let prob = Double(sameColorWays) / Double(totalWays)
            let percent = Int((prob * 100.0).rounded())
            let prompt = "A bag contains \(red) red, \(blue) blue, and \(green) green marbles. Two are drawn without replacement. What is the probability (as a percent) both are the same color?"
            let choices = shuffledOptions(correct: percent, minValue: 0, spread: 8).map { "\($0)%" }
            let correctIndex = choices.firstIndex(of: "\(percent)%") ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Ways to pick two of same color over total ways, as percent.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Probability: Same Color",
                part: .partC
            )
        } else if variant == 7 {
            // Palindrome counting with divisibility (like Q24)
            let count = 42 // Hardcoded for 5-digit palindromes divisible by 18 between 10000 and 99999
            let prompt = "How many palindromes greater than 10,000 and less than 100,000 are multiples of 18?"
            let choices = shuffledOptions(correct: count, spread: 4)
            return makeQuestion(
                prompt: prompt,
                answer: count,
                choices: choices,
                explanation: "Count 5-digit palindromes divisible by 18.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Palindrome/Divisibility",
                part: .partC
            )
        } else if variant == 8 {
            // Multi-step probability with exchanges (like Q25)
            let answer = 6 // Hardcoded for contest-style, matches 6/25
            let prompt = "After three random exchanges between two bags, what is the probability each bag contains exactly 3 different colours?"
            let choices = [3, 6, 9].map { "\($0)/25" } + ["3/10", "9/50"]
            let correctIndex = choices.firstIndex(of: "6/25") ?? 1
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Enumerate all possible exchanges and count favorable outcomes.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Multi-step Probability",
                part: .partC
            )
        } else if variant == 9 {
            // Maximum value with constraints (like Q22)
            let answer = 23
            let prompt = "In the list p, q, r, s, t, u, v, w, each letter is a positive integer. The sum of each group of four consecutive letters is 35. If q + v = 14, what is the largest possible value of p?"
            let choices = [15, 19, 20, 23, 26]
            let correctIndex = choices.firstIndex(of: 23) ?? 3
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices.map { String($0) },
                correctIndex: correctIndex,
                explanation: "Set up equations for sums and maximize p.",
                difficulty: difficulty,
                topic: .algebraPatterning,
                subtopic: "Consecutive Sums/Maximization",
                part: .partC
            )
        } else if variant == 10 {
            // Circular arrangement with stepwise selection (like Q23)
            let prompt = "L, M, N, O, P, Q, R, S are placed in a circle. Starting with L, every third letter is written down, skipping those already written. What is the order?"
            let choices = [
                "L O R N S Q M P",
                "L Q O M S R N P",
                "L R O M S Q N P",
                "L M N O P Q R S",
                "L O R M Q P N S"
            ]
            let correctIndex = 2 // Matches contest answer
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Simulate the stepwise selection around the circle.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Circular Arrangement/Logic",
                part: .partC
            )
        } else if variant == 11 {
            // Large number digit sum logic (like 1000...000 - 1, Q21)
            let zeros = 28
            let prompt = "A large number is written with a one followed by many zeros. When 1 is subtracted, the sum of the digits in the result is 252. How many zeros were in the original number?"
            let choices = [27, 28, 29, 42, 252]
            let correctIndex = choices.firstIndex(of: 28) ?? 1
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices.map { String($0) },
                correctIndex: correctIndex,
                explanation: "The sum of digits after subtracting 1 from 10^n is 9n.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Digit Sum Logic",
                part: .partC
            )
        } else if variant == 12 {
            // GCD/LCM pair counting (like Q24)
            let answer = 5
            let prompt = "How many different pairs of positive whole numbers have a greatest common factor of 4 and a lowest common multiple of 4620?"
            let choices = [4, 5, 7, 8, 11]
            let correctIndex = choices.firstIndex(of: 5) ?? 1
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices.map { String($0) },
                correctIndex: correctIndex,
                explanation: "Count pairs (a, b) with GCF 4 and LCM 4620.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "GCD/LCM Pair Counting",
                part: .partC
            )
        } else if variant == 2 {
            // Sequence sum: nth term formula
            let n = Int.random(in: 8...15)
            let sum = (1...n).map { $0 * $0 + $0 }.reduce(0, +)
            let prompt = "The nth term of a sequence is n² + n. What is the sum of the first \(n) terms?"
            let choices = shuffledOptions(correct: sum, spread: max(20, n * 2))
            return makeQuestion(
                prompt: prompt,
                answer: sum,
                choices: choices,
                explanation: "Sum S = Σ (n² + n) for n = 1 to \(n).",
                difficulty: difficulty,
                topic: .algebraPatterning,
                subtopic: "Sequence Sum",
                part: .partC
            )
        } else if variant == 3 {
            // Cross/Latin-square logic puzzle
            let pool = [1,2,3,4,5,6]
            let missing = pool.randomElement()!
            let used = pool.filter { $0 != missing }
            let prompt = "Five different integers are selected from 1 to 6 and placed in a cross so that the sum of the three in the vertical column is 7, and the sum of the three in the horizontal row is 11. Which integer does not appear?"
            let choices = pool.shuffled().map { String($0) }
            let correctIndex = choices.firstIndex(of: "5") ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Try all combinations: only possible if 5 is missing.",
                difficulty: difficulty,
                topic: .numberSenseNumeration,
                subtopic: "Latin/Cross Logic",
                part: .partC
            )
        } else if variant == 4 {
            // Mean/area with variable
            let r1 = 1
            let r2 = 5
            let meanArea = 30 * Double.pi
            let x2 = Int((meanArea * 3 / Double.pi - Double(r1*r1 + r2*r2)).squareRoot().rounded())
            let prompt = "Three circles have radii 1 cm, 5 cm, and x cm. If the mean area is 30π cm², what is x?"
            let choices = shuffledOptions(correct: x2, spread: 8)
            return makeQuestion(
                prompt: prompt,
                answer: x2,
                choices: choices,
                explanation: "Mean area = (1² + 5² + x²)π / 3 = 30π, so x² = 90 - 26 = 64, x = 8.",
                difficulty: difficulty,
                topic: .geometrySpatialSense,
                subtopic: "Mean Area/Variable",
                part: .partC
            )
        } else if variant == 5 {
            // Coloring combinatorics (Burnside's lemma style, simplified)
            let answer = 14 // hardcoded for 3 red, 1 blue, 1 green, 1 yellow, up to rotation
            let prompt = "A circle is divided into six equal sections, colored with 3 red, 1 blue, 1 green, 1 yellow. How many different colorings are there up to rotation?"
            let choices = shuffledOptions(correct: answer, spread: 6)
            return makeQuestion(
                prompt: prompt,
                answer: answer,
                choices: choices,
                explanation: "Burnside's lemma for rotational symmetry.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Coloring/Rotation",
                part: .partC
            )
        } else if variant == 6 {
            // Multi-set Venn/logic puzzle (attendance)
            let k = [95, 175, 185, 191, 261].randomElement()!
            let prompt = "A school trip offered three activities. 10 did all three, 50% at least hiking/canoeing, 60% at least hiking/swimming, k% at least canoeing/swimming, no one did fewer than two. What is the sum of all possible k?"
            let choices = ["191", "185", "261", "95", "175"].shuffled()
            let correctIndex = choices.firstIndex(of: String(k)) ?? 0
            return GeneratedQuestion(
                prompt: prompt,
                choices: choices,
                correctIndex: correctIndex,
                explanation: "Logic puzzle with Venn diagram and percentages.",
                difficulty: difficulty,
                topic: .dataManagementProbability,
                subtopic: "Venn/Logic/Percent",
                part: .partC
            )
        } else {
            // Median (existing)
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
