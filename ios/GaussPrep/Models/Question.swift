import Foundation

enum Topic: String, CaseIterable, Codable {
    case arithmetic
    case algebra
    case geometry
    case numberTheory
    case logic

    var title: String {
        switch self {
        case .arithmetic:
            return "Arithmetic"
        case .algebra:
            return "Algebra"
        case .geometry:
            return "Geometry"
        case .numberTheory:
            return "Number Theory"
        case .logic:
            return "Logic"
        }
    }
}

struct GeneratedQuestion: Identifiable, Codable {
    let id: UUID
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String
    let difficulty: Int
    let topic: Topic

    init(
        id: UUID = UUID(),
        prompt: String,
        choices: [String],
        correctIndex: Int,
        explanation: String,
        difficulty: Int,
        topic: Topic
    ) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correctIndex
        self.explanation = explanation
        self.difficulty = difficulty
        self.topic = topic
    }
}

struct SessionStats: Codable {
    var correctAnswers: Int
    var totalAnswers: Int
    var currentDifficulty: Int
    var longestStreak: Int
    var currentStreak: Int

    static let initial = SessionStats(
        correctAnswers: 0,
        totalAnswers: 0,
        currentDifficulty: 4,
        longestStreak: 0,
        currentStreak: 0
    )

    var accuracy: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
}
