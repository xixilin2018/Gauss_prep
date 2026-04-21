import Foundation

enum Topic: String, CaseIterable, Codable {
    case numberSenseNumeration
    case geometrySpatialSense
    case algebraPatterning
    case dataManagementProbability

    var title: String {
        switch self {
        case .numberSenseNumeration:
            return "Number Sense & Numeration"
        case .geometrySpatialSense:
            return "Geometry & Spatial Sense"
        case .algebraPatterning:
            return "Algebra & Patterning"
        case .dataManagementProbability:
            return "Data Mgmt & Probability"
        }
    }
}

enum GaussPart: String, Codable {
    case partA
    case partB
    case partC

    var title: String {
        switch self {
        case .partA:
            return "Part A"
        case .partB:
            return "Part B"
        case .partC:
            return "Part C"
        }
    }

    var descriptor: String {
        switch self {
        case .partA:
            return "Foundation"
        case .partB:
            return "Connection"
        case .partC:
            return "Ingenuity"
        }
    }
}

enum GraphStyle: String, Codable {
    case line
    case bar
}

struct GraphPoint: Codable {
    let x: Double
    let y: Double
}

struct QuestionGraph: Codable {
    let style: GraphStyle
    let points: [GraphPoint]
    let xLabel: String
    let yLabel: String
    let title: String?
}

struct GeneratedQuestion: Identifiable, Codable {
    let id: UUID
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String
    let difficulty: Int
    let topic: Topic
    let subtopic: String
    let part: GaussPart
    let graph: QuestionGraph?

    init(
        id: UUID = UUID(),
        prompt: String,
        choices: [String],
        correctIndex: Int,
        explanation: String,
        difficulty: Int,
        topic: Topic,
        subtopic: String,
        part: GaussPart,
        graph: QuestionGraph? = nil
    ) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correctIndex
        self.explanation = explanation
        self.difficulty = difficulty
        self.topic = topic
        self.subtopic = subtopic
        self.part = part
        self.graph = graph
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
