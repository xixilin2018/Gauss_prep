import Foundation

enum SessionMode {
    case adaptivePractice
    case partCPractice
    case mockContest
}

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    @Published private(set) var currentQuestion: GeneratedQuestion
    @Published var selectedChoiceIndex: Int? = nil
    @Published var feedbackText: String = ""
    @Published var isAnswerSubmitted = false
    @Published private(set) var stats: SessionStats
    @Published private(set) var mode: SessionMode = .adaptivePractice
    @Published private(set) var questionNumber = 1
    @Published private(set) var totalQuestions = 0
    @Published private(set) var remainingSeconds: Int? = nil
    @Published private(set) var isSessionComplete = false
    @Published private(set) var completionMessage = ""
    @Published private(set) var mockScore = 0
    @Published private(set) var mockPossibleScore = 0
    @Published private(set) var partAScore = 0
    @Published private(set) var partBScore = 0
    @Published private(set) var partCScore = 0
    @Published private(set) var partAPossible = 0
    @Published private(set) var partBPossible = 0
    @Published private(set) var partCPossible = 0

    private let generator = QuestionGenerator()
    private let storage = StatsStorage()
    private var adaptiveEngine: AdaptiveEngine
    private var timer: Timer?
    private var mockQuestions: [GeneratedQuestion] = []
    private var mockIndex = 0
    private var mockCorrect = 0
    private var mockAnswered = 0

    private let mockQuestionCount = 25
    private let mockDurationSeconds = 60 * 60

    init() {
        let loadedStats = storage.load()
        stats = loadedStats
        adaptiveEngine = AdaptiveEngine(startingDifficulty: loadedStats.currentDifficulty)
        currentQuestion = generator.generateQuestion(difficulty: loadedStats.currentDifficulty)
    }

    deinit {
        timer?.invalidate()
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
            feedbackText = mode == .mockContest ? "Correct." : "Correct. " + currentQuestion.explanation
        } else {
            stats.currentStreak = 0
            let answer = currentQuestion.choices[currentQuestion.correctIndex]
            feedbackText = mode == .mockContest
                ? "Incorrect. Correct answer: \(answer)."
                : "Not quite. The correct answer is \(answer). " + currentQuestion.explanation
        }

        if mode == .adaptivePractice {
            stats.currentDifficulty = adaptiveEngine.registerAnswer(correct: isCorrect)
        } else {
            let part = currentQuestion.part
            let partPoints = points(for: part)

            mockAnswered += 1
            mockPossibleScore += partPoints
            incrementPossible(for: part, by: partPoints)
            if isCorrect {
                mockCorrect += 1
                mockScore += partPoints
                incrementScore(for: part, by: partPoints)
            }
        }

        storage.save(stats)

        if mode == .mockContest && mockAnswered >= mockQuestionCount {
            completeMockContest(timedOut: false)
        }
    }

    func nextQuestion() {
        guard !isSessionComplete else { return }

        selectedChoiceIndex = nil
        feedbackText = ""
        isAnswerSubmitted = false

        if mode == .mockContest {
            mockIndex += 1
            guard mockIndex < mockQuestions.count else {
                completeMockContest(timedOut: false)
                return
            }
            questionNumber = mockIndex + 1
            currentQuestion = mockQuestions[mockIndex]
            return
        }

        if mode == .partCPractice {
            currentQuestion = generator.generateQuestion(part: .partC)
            return
        }

        currentQuestion = generator.generateQuestion(difficulty: stats.currentDifficulty)
    }

    func startAdaptivePractice() {
        stopTimer()
        mode = .adaptivePractice
        totalQuestions = 0
        questionNumber = 1
        remainingSeconds = nil
        isSessionComplete = false
        completionMessage = ""
        selectedChoiceIndex = nil
        feedbackText = ""
        isAnswerSubmitted = false
        currentQuestion = generator.generateQuestion(difficulty: stats.currentDifficulty)
    }

    func startPartCPractice() {
        stopTimer()
        mode = .partCPractice
        totalQuestions = 0
        questionNumber = 1
        remainingSeconds = nil
        isSessionComplete = false
        completionMessage = ""
        selectedChoiceIndex = nil
        feedbackText = ""
        isAnswerSubmitted = false
        currentQuestion = generator.generateQuestion(part: .partC)
    }

    func startMockContest() {
        stopTimer()
        mode = .mockContest
        totalQuestions = mockQuestionCount
        questionNumber = 1
        remainingSeconds = mockDurationSeconds
        isSessionComplete = false
        completionMessage = ""
        selectedChoiceIndex = nil
        feedbackText = ""
        isAnswerSubmitted = false

        mockCorrect = 0
        mockAnswered = 0
        mockScore = 0
        mockPossibleScore = 0
        partAScore = 0
        partBScore = 0
        partCScore = 0
        partAPossible = 0
        partBPossible = 0
        partCPossible = 0
        mockIndex = 0
        mockQuestions = buildMockQuestionSet()
        currentQuestion = mockQuestions[0]

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tickTimer()
        }
    }

    var timerLabel: String {
        guard let remainingSeconds else { return "" }
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func buildMockQuestionSet() -> [GeneratedQuestion] {
        var questions: [GeneratedQuestion] = []
        questions += (0..<8).map { _ in generator.generateQuestion(part: .partA) }
        questions += (0..<9).map { _ in generator.generateQuestion(part: .partB) }
        questions += (0..<8).map { _ in generator.generateQuestion(part: .partC) }
        return questions
    }

    private func tickTimer() {
        guard mode == .mockContest else { return }
        guard let remaining = remainingSeconds else { return }
        if remaining <= 1 {
            remainingSeconds = 0
            completeMockContest(timedOut: true)
            return
        }
        remainingSeconds = remaining - 1
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func completeMockContest(timedOut: Bool) {
        guard !isSessionComplete else { return }
        stopTimer()
        isSessionComplete = true

        let answered = mockAnswered
        let accuracy = answered > 0 ? Int((Double(mockCorrect) / Double(answered) * 100.0).rounded()) : 0
        let timeoutText = timedOut ? " (Time Up)" : ""
        completionMessage = "Mock Complete\(timeoutText): Score \(mockScore)/\(maximumMockScore), \(mockCorrect)/\(mockQuestionCount) correct, \(accuracy)% on attempted questions."
    }

    private var maximumMockScore: Int {
        (8 * points(for: .partA)) + (9 * points(for: .partB)) + (8 * points(for: .partC))
    }

    private func points(for part: GaussPart) -> Int {
        switch part {
        case .partA:
            return 5
        case .partB:
            return 6
        case .partC:
            return 8
        }
    }

    private func incrementScore(for part: GaussPart, by value: Int) {
        switch part {
        case .partA:
            partAScore += value
        case .partB:
            partBScore += value
        case .partC:
            partCScore += value
        }
    }

    private func incrementPossible(for part: GaussPart, by value: Int) {
        switch part {
        case .partA:
            partAPossible += value
        case .partB:
            partBPossible += value
        case .partC:
            partCPossible += value
        }
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
