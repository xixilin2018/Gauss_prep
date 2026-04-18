import Foundation

final class AdaptiveEngine {
    private(set) var difficulty: Int
    private var recentResults: [Bool] = []
    private var questionsSinceLastAdjustment = 0

    private let minDifficulty = 1
    private let maxDifficulty = 10
    private let windowSize = 8
    private let adjustmentCooldown = 3

    init(startingDifficulty: Int) {
        difficulty = max(min(startingDifficulty, maxDifficulty), minDifficulty)
    }

    func registerAnswer(correct: Bool) -> Int {
        recentResults.append(correct)
        if recentResults.count > windowSize {
            recentResults.removeFirst()
        }

        questionsSinceLastAdjustment += 1
        guard questionsSinceLastAdjustment >= adjustmentCooldown else {
            return difficulty
        }

        let accuracy = rollingAccuracy
        if accuracy >= 0.8 {
            difficulty = min(difficulty + 1, maxDifficulty)
            questionsSinceLastAdjustment = 0
        } else if accuracy <= 0.5 {
            difficulty = max(difficulty - 1, minDifficulty)
            questionsSinceLastAdjustment = 0
        }

        return difficulty
    }

    private var rollingAccuracy: Double {
        guard !recentResults.isEmpty else { return 0.0 }
        let correctCount = recentResults.filter { $0 }.count
        return Double(correctCount) / Double(recentResults.count)
    }
}
