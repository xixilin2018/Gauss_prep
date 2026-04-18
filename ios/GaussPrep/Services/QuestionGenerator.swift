import Foundation

final class QuestionGenerator {
    func generateQuestion(difficulty: Int, preferredTopic: Topic? = nil) -> GeneratedQuestion {
        let boundedDifficulty = max(1, min(10, difficulty))
        let topic = preferredTopic ?? Topic.allCases.randomElement() ?? .arithmetic

        switch topic {
        case .arithmetic:
            return generateArithmetic(difficulty: boundedDifficulty)
        case .algebra:
            return generateAlgebra(difficulty: boundedDifficulty)
        case .geometry:
            return generateGeometry(difficulty: boundedDifficulty)
        case .numberTheory:
            return generateNumberTheory(difficulty: boundedDifficulty)
        case .logic:
            return generateLogic(difficulty: boundedDifficulty)
        }
    }

    private func generateArithmetic(difficulty: Int) -> GeneratedQuestion {
        let n = Int.random(in: (5 + difficulty)...(10 + difficulty * 2))
        let sum = n * (n + 1) / 2
        let prompt = "What is the sum of the first \(n) positive integers?"

        let options = shuffledOptions(correct: sum, spread: max(3, difficulty))
        let correctIndex = options.firstIndex(of: String(sum)) ?? 0

        return GeneratedQuestion(
            prompt: prompt,
            choices: options,
            correctIndex: correctIndex,
            explanation: "Use n(n+1)/2. Here n = \(n), so the sum is \(n) x \(n + 1) / 2 = \(sum).",
            difficulty: difficulty,
            topic: .arithmetic
        )
    }

    private func generateAlgebra(difficulty: Int) -> GeneratedQuestion {
        let x = Int.random(in: 2...(6 + difficulty))
        let a = Int.random(in: 2...(5 + max(1, difficulty / 2)))
        let b = Int.random(in: 1...(5 + difficulty))
        let c = a * x + b

        let prompt = "Solve for x: \(a)x + \(b) = \(c)"
        let options = shuffledOptions(correct: x, spread: max(2, difficulty / 2 + 1))
        let correctIndex = options.firstIndex(of: String(x)) ?? 0

        return GeneratedQuestion(
            prompt: prompt,
            choices: options,
            correctIndex: correctIndex,
            explanation: "Subtract \(b) from both sides to get \(a)x = \(c - b). Then divide by \(a), so x = \(x).",
            difficulty: difficulty,
            topic: .algebra
        )
    }

    private func generateGeometry(difficulty: Int) -> GeneratedQuestion {
        let width = Int.random(in: 2...(6 + difficulty))
        let length = Int.random(in: (width + 1)...(width + 4 + difficulty))
        let askArea = Bool.random()

        if askArea {
            let area = width * length
            let prompt = "A rectangle has width \(width) cm and length \(length) cm. What is its area in cm^2?"
            let options = shuffledOptions(correct: area, spread: max(3, difficulty))
            let correctIndex = options.firstIndex(of: String(area)) ?? 0

            return GeneratedQuestion(
                prompt: prompt,
                choices: options,
                correctIndex: correctIndex,
                explanation: "Area of a rectangle is width x length = \(width) x \(length) = \(area).",
                difficulty: difficulty,
                topic: .geometry
            )
        }

        let perimeter = 2 * (width + length)
        let prompt = "A rectangle has width \(width) cm and length \(length) cm. What is its perimeter in cm?"
        let options = shuffledOptions(correct: perimeter, spread: max(4, difficulty))
        let correctIndex = options.firstIndex(of: String(perimeter)) ?? 0

        return GeneratedQuestion(
            prompt: prompt,
            choices: options,
            correctIndex: correctIndex,
            explanation: "Perimeter of a rectangle is 2 x (width + length) = 2 x (\(width) + \(length)) = \(perimeter).",
            difficulty: difficulty,
            topic: .geometry
        )
    }

    private func generateNumberTheory(difficulty: Int) -> GeneratedQuestion {
        let divisor = Int.random(in: 3...(6 + difficulty / 2))
        let quotient = Int.random(in: 5...(12 + difficulty))
        let remainder = Int.random(in: 1..<divisor)
        let number = divisor * quotient + remainder

        let prompt = "When \(number) is divided by \(divisor), what is the remainder?"
        let options = shuffledOptions(correct: remainder, minValue: 0, spread: 2)
        let correctIndex = options.firstIndex(of: String(remainder)) ?? 0

        return GeneratedQuestion(
            prompt: prompt,
            choices: options,
            correctIndex: correctIndex,
            explanation: "Write \(number) = \(divisor) x \(quotient) + \(remainder), so the remainder is \(remainder).",
            difficulty: difficulty,
            topic: .numberTheory
        )
    }

    private func generateLogic(difficulty: Int) -> GeneratedQuestion {
        let start = Int.random(in: 2...(4 + difficulty / 2))
        let step = Int.random(in: 2...(3 + difficulty / 3))
        let terms = [start, start + step, start + 2 * step, start + 3 * step]
        let missing = start + 4 * step

        let prompt = "Find the next number in the pattern: \(terms[0]), \(terms[1]), \(terms[2]), \(terms[3]), ..."
        let options = shuffledOptions(correct: missing, spread: max(2, difficulty / 2 + 1))
        let correctIndex = options.firstIndex(of: String(missing)) ?? 0

        return GeneratedQuestion(
            prompt: prompt,
            choices: options,
            correctIndex: correctIndex,
            explanation: "This is an arithmetic sequence with common difference \(step), so the next term is \(missing).",
            difficulty: difficulty,
            topic: .logic
        )
    }

    private func shuffledOptions(correct: Int, minValue: Int = 1, spread: Int) -> [String] {
        var values = Set<Int>()
        values.insert(correct)

        while values.count < 4 {
            let offset = Int.random(in: -spread...spread)
            let candidate = max(minValue, correct + offset)
            values.insert(candidate)
        }

        return values.map(String.init).shuffled()
    }
}
