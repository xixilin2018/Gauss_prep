import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PracticeSessionViewModel()
    @State private var selectedMode: SessionMode = .adaptivePractice

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
            .onAppear {
                selectedMode = viewModel.mode
            }
            .onChange(of: viewModel.mode) { newValue in
                selectedMode = newValue
            }
        }
    }

    private var modeControls: some View {
        Picker("Mode", selection: $selectedMode) {
            Text("Practice").tag(SessionMode.adaptivePractice)
            Text("Part C").tag(SessionMode.partCPractice)
            Text("Mock").tag(SessionMode.mockContest)
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedMode) { newValue in
            withAnimation(.easeInOut(duration: 0.2)) {
                switch newValue {
                case .adaptivePractice:
                    viewModel.startAdaptivePractice()
                case .partCPractice:
                    viewModel.startPartCPractice()
                case .mockContest:
                    viewModel.startMockContest()
                }
            }
        }
    }

    private var statsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sessionTitle)
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

            if let graph = viewModel.currentQuestion.graph {
                GraphCardView(graph: graph)
            }
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
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .disabled(viewModel.isAnswerSubmitted)
            }
        }
    }

    private var sessionTitle: String {
        switch viewModel.mode {
        case .adaptivePractice:
            return "Practice Question"
        case .partCPractice:
            return "Practice Part C"
        case .mockContest:
            return "Timed Mock Contest"
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

                Button("Practice Part C") {
                    viewModel.startPartCPractice()
                }
                .buttonStyle(.bordered)

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

private struct GraphCardView: View {
    let graph: QuestionGraph

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = graph.title {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            GraphPlotView(graph: graph)
                .frame(height: 180)

            HStack {
                Text(graph.xLabel)
                Spacer()
                Text(graph.yLabel)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct GraphPlotView: View {
    let graph: QuestionGraph

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let padding: CGFloat = 16
            let plotWidth = max(1, width - 2 * padding)
            let plotHeight = max(1, height - 2 * padding)
            let maxX = max(graph.points.map { $0.x }.max() ?? 1, 1)
            let maxY = max(graph.points.map { $0.y }.max() ?? 1, 1)

            ZStack {
                Path { path in
                    // Y axis
                    path.move(to: CGPoint(x: padding, y: padding))
                    path.addLine(to: CGPoint(x: padding, y: padding + plotHeight))
                    // X axis
                    path.move(to: CGPoint(x: padding, y: padding + plotHeight))
                    path.addLine(to: CGPoint(x: padding + plotWidth, y: padding + plotHeight))
                }
                .stroke(Color.secondary.opacity(0.6), lineWidth: 1)

                if graph.style == .line {
                    Path { path in
                        for (index, point) in graph.points.enumerated() {
                            let x = padding + CGFloat(point.x / maxX) * plotWidth
                            let y = padding + plotHeight - CGFloat(point.y / maxY) * plotHeight
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)

                    ForEach(Array(graph.points.enumerated()), id: \.offset) { _, point in
                        let x = padding + CGFloat(point.x / maxX) * plotWidth
                        let y = padding + plotHeight - CGFloat(point.y / maxY) * plotHeight
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                } else {
                    let count = max(graph.points.count, 1)
                    let barWidth = plotWidth / CGFloat(count) * 0.6
                    ForEach(Array(graph.points.enumerated()), id: \.offset) { index, point in
                        let normalized = CGFloat(point.y / maxY)
                        let barHeight = normalized * plotHeight
                        let xStep = plotWidth / CGFloat(count)
                        let x = padding + xStep * CGFloat(index) + xStep * 0.5
                        let y = padding + plotHeight - barHeight / 2
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: barWidth, height: max(1, barHeight))
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
