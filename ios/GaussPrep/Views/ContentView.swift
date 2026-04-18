import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PracticeSessionViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isSessionComplete {
                    completionPanel
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        modeControls
                        statsPanel
                        questionPanel
                        answerPanel
                        actionButtons
                        feedbackPanel
                        Spacer()
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Gauss Prep")
        }
    }

    private var modeControls: some View {
        HStack(spacing: 10) {
            Button("Adaptive Practice") {
                viewModel.startAdaptivePractice()
            }
            .buttonStyle(.borderedProminent)

            Button("Mock Contest (25)") {
                viewModel.startMockContest()
            }
            .buttonStyle(.bordered)
        }
    }

    private var statsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.mode == .mockContest ? "Timed Mock Contest" : "Adaptive Practice")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                Text("Accuracy: \(Int(viewModel.stats.accuracy * 100))%")
                Text("Difficulty: \(viewModel.stats.currentDifficulty)")
                Text("Streak: \(viewModel.stats.currentStreak)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            if viewModel.mode == .mockContest {
                HStack(spacing: 16) {
                    Text("Question: \(viewModel.questionNumber)/\(viewModel.totalQuestions)")
                    Text("Time Left: \(viewModel.timerLabel)")
                    Text("Score: \(viewModel.mockScore)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
    }

    private var questionPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(viewModel.currentQuestion.topic.title)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())

                Text("\(viewModel.currentQuestion.part.title): \(viewModel.currentQuestion.part.descriptor)")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(Capsule())
            }

            Text(viewModel.currentQuestion.subtopic)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Text(viewModel.currentQuestion.prompt)
                .font(.title3)
                .fontWeight(.medium)
        }
    }

    private var answerPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.currentQuestion.choices.indices, id: \.self) { index in
                Button {
                    viewModel.selectChoice(index: index)
                } label: {
                    HStack {
                        Text(String(Character(UnicodeScalar(65 + index)!)) + ".")
                            .fontWeight(.semibold)
                        Text(viewModel.currentQuestion.choices[index])
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .background(backgroundColor(for: index))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isAnswerSubmitted)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("Submit") {
                viewModel.submitAnswer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canSubmit)

            Button("Next") {
                viewModel.nextQuestion()
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isAnswerSubmitted || viewModel.isSessionComplete)
        }
    }

    private var completionPanel: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Session Complete")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(viewModel.completionMessage)
                .font(.title3)

            VStack(alignment: .leading, spacing: 8) {
                Text("Part Score Breakdown")
                    .font(.headline)
                Text("Part A: \(viewModel.partAScore)/\(viewModel.partAPossible)")
                Text("Part B: \(viewModel.partBScore)/\(viewModel.partBPossible)")
                Text("Part C: \(viewModel.partCScore)/\(viewModel.partCPossible)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("Start New Mock") {
                    viewModel.startMockContest()
                }
                .buttonStyle(.borderedProminent)

                Button("Back To Practice") {
                    viewModel.startAdaptivePractice()
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding(24)
    }

    @ViewBuilder
    private var feedbackPanel: some View {
        if viewModel.isAnswerSubmitted {
            Text(viewModel.feedbackText)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func backgroundColor(for index: Int) -> Color {
        if !viewModel.isAnswerSubmitted {
            return viewModel.selectedChoiceIndex == index ? Color.blue.opacity(0.15) : Color.gray.opacity(0.08)
        }

        if index == viewModel.currentQuestion.correctIndex {
            return Color.green.opacity(0.2)
        }

        if index == viewModel.selectedChoiceIndex {
            return Color.red.opacity(0.2)
        }

        return Color.gray.opacity(0.08)
    }
}

#Preview {
    ContentView()
}
