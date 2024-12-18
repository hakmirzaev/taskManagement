//
//  TaskProgressView.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 13/12/24.
//

import SwiftUI
import Charts
import SwiftData

struct TaskProgressView: View {
    @Query private var tasks: [Task]
    @State private var selectedTimeFrame: TimeFrame = .day
    @State private var progressData: [ProgressData] = []
    @State private var animatedValues: [Double] = []
    @State private var selectedBar: ProgressData? // For interactivity

    enum TimeFrame: String, CaseIterable, Identifiable {
        case day = "Daily"
        case week = "Weekly"
        case month = "Monthly"
        
        var id: String { self.rawValue }
    }

    struct ProgressData: Identifiable {
        let id = UUID()
        let label: String // e.g., "Mon", "Week 1", "Jan"
        let percentage: Double
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases) { frame in
                        Text(frame.rawValue).tag(frame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Chart {
                    ForEach(Array(progressData.enumerated()), id: \.element.id) { index, data in
                        let animatedValue = animatedValues[safe: index] ?? 0
                        
                        BarMark(
                            x: .value("Time Period", data.label),
                            y: .value("Percentage", animatedValue)
                        )
                        .foregroundStyle(.blue.gradient)
                        .cornerRadius(8)
                        .annotation(position: .top) {
                            Text("\(Int(animatedValue))%")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .accessibilityLabel(Text(data.label))
                        .accessibilityValue(Text("\(Int(animatedValue))%"))
                    }
                }
                .frame(height: 300)
                .padding()
                .overlay(
                    GeometryReader { proxy in
                        ZStack {
                            ForEach(progressData) { data in
                                if let index = progressData.firstIndex(where: { $0.id == data.id }),
                                   let barFrame = calculateBarFrame(for: index, in: proxy) {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .contentShape(Rectangle()) // Ensures taps register only on the bar area
                                        .frame(width: barFrame.width, height: barFrame.height)
                                        .position(x: barFrame.midX, y: barFrame.midY)
                                        .onTapGesture {
                                            selectedBar = data
                                            print("Tapped on \(data.label)")
                                        }
                                }
                            }
                        }
                    }
                )
                
                if let selectedBar = selectedBar {
                    Text("You have completed \(Int(selectedBar.percentage))% of tasks in \(selectedBar.label)")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
            .onAppear {
                loadProgressData()
                animateBars()
            }
            .onChange(of: selectedTimeFrame) { _ in
                loadProgressData()
                animateBars()
            }
            .navigationTitle("Progress chart")
        }
    }

    // MARK: - Calculate Bar Frame for Interactivity#imageLiteral(resourceName:#imageLiteral(resourceName: "simulator_screenshot_C2FBE3F4-27EF-4E93-8AEE-C82B3F907411.png") "simulator_screenshot_ADB86817-0F74-4005-8087-125169B22D7C.png")
    private func calculateBarFrame(for index: Int, in proxy: GeometryProxy) -> CGRect? {
        guard index < progressData.count else { return nil }
        let barWidth = proxy.size.width / CGFloat(progressData.count)
        let barHeight = proxy.size.height * CGFloat(animatedValues[safe: index] ?? 0) / 100.0
        let xOffset = CGFloat(index) * barWidth + barWidth / 2
        let yOffset = proxy.size.height - barHeight / 2
        return CGRect(x: xOffset - barWidth / 2, y: yOffset - barHeight, width: barWidth, height: barHeight)
    }

    // MARK: - Load Progress Data
    func loadProgressData() {
        progressData = calculateProgressData(for: selectedTimeFrame)
        animatedValues = Array(repeating: 0, count: progressData.count)
    }

    // MARK: - Calculate Progress Data
    func calculateProgressData(for timeFrame: TimeFrame) -> [ProgressData] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeFrame {
        case .day:
            return (0..<7).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
                let label = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                return calculateProgress(for: date, granularity: .day, label: label)
            }.reversed()
            
        case .week:
            return (0..<4).map { weekOffset in
                let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now)!
                let label = "Week \(calendar.component(.weekOfYear, from: weekStart))"
                return calculateProgress(for: weekStart, granularity: .weekOfYear, label: label)
            }.reversed()
            
        case .month:
            return (0..<6).map { monthOffset in
                let monthStart = calendar.date(byAdding: .month, value: -monthOffset, to: now)!
                let label = calendar.shortMonthSymbols[calendar.component(.month, from: monthStart) - 1]
                return calculateProgress(for: monthStart, granularity: .month, label: label)
            }.reversed()
        }
    }

    func calculateProgress(for date: Date, granularity: Calendar.Component, label: String) -> ProgressData {
        let calendar = Calendar.current
        let filteredTasks = tasks.filter { task in
            calendar.isDate(task.creationDate, equalTo: date, toGranularity: granularity)
        }
        let completedTasks = filteredTasks.filter { $0.isCompleted }
        let totalTasks = filteredTasks.count
        let percentage = totalTasks == 0 ? 0 : (Double(completedTasks.count) / Double(totalTasks)) * 100

        return ProgressData(label: label, percentage: percentage)
    }

    // MARK: - Animate Bars
    func animateBars() {
        for (index, data) in progressData.enumerated() {
            withAnimation(.easeOut(duration: 1.0).delay(Double(index) * 0.1)) {
                if index < animatedValues.count {
                    animatedValues[index] = data.percentage
                }
            }
        }
    }
}

// MARK: - Safe Array Indexing
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
