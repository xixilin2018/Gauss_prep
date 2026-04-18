import Foundation

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    @Published private(set) var currentQuestion: GeneratedQuestion
    @Published var selectedChoiceIndex: Int? = nil
    @Published var feedbackText: String = ""
    @Published var isAnswerSubmitted = false
    @Published private(set) var stats: SessionStats

    private let generator = QuestionGenerator()
    private let storage = StatsStorage()
    private var adaptiveEngine: AdaptiveEngine

    init() {
        stats = storage.load()
        adaptiveEngine = AdaptiveEngine(startingDifficulty: stats.currentDifficulty)
        currentQuestion = generator.generateQuestion(difficulty: stats.currentDifficulty)
    }

    var canSubmit: Bool {
        selectedChoiceIndex != nil && !isAnswerSubmitted
    }

    func selectChoice(index: Int) {
        guard !isAnswerSubmitted else { return }
        selectedChoiceIndex = index
    }

    func submitAnswer() {
        guard let selectedChoiceIndex else { return }
        guard !isAnswerSubmitted else { return }

        let isCorrect = selectedChoiceIndex == currentQuestion.correctIndex
        isAnswerSubmitted = true

        stats.totalAnswers += 1
        if isCorrect {
            stats.correctAnswers += 1
            stats.currentStreak += 1
            stats.longestStreak = max(stats.longestStreak, stats.currentStreak)
            feedbackText = "Correct. " + currentQuestion.explanation
        } else {
            stats.currentStreak = 0
            let answer = currentQuestion.choices[currentQuestion.correctIndex]
            feedbackText = "Not quite. The correct answer is \(answer). " + currentQuestion.explanation
        }

        stats.currentDifficulty = adaptiveEngine.registerAnswer(correct: isCorrect)
        storage.save(stats)
    }

    func nextQuestion() {
        selectedChoiceIndex = nil
        feedbackText = ""
        isAnswerSubmitted = false
        currentQuestion = generator.generateQuestion(difficulty: stats.currentDifficulty)
    }
}

private struct StatsStorage {
    private let key = "gauss.adaptive.session.stats"

    func load() -> SessionStats {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return .initial
        }

        do {
            return try JSONDecoder().decode(SessionStats.self, from: data)
        } catch {
            return .initial
        }
    }

    func save(_ stats: SessionStats) {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
