//
//  ContainerView.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 12/12/24.
//

import SwiftUI

struct TaskRowView: View {
    @Bindable var task: Task
    /// Model Context
    @Environment(\.modelContext) private var context
    /// Direct TextField Binding Making SwiftData to Crash, Hope it will be rectified in the Further Releases!
    /// Workaround use separate @State Variable
    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8, content: {
                TextField("Task Title", text: $taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .onSubmit {
                        /// If TaskTitle is Empty, Then Deleting the Task!
                        /// You can remove this feature, if you don't want to delete the Task even after the TextField is Empty
                        if taskTitle == "" {
                            context.delete(task)
                            try? context.save()
                        }
                    }
                    .onChange(of: taskTitle, initial: false) { oldValue, newValue in
                        task.taskTitle = newValue
                    }
                    .onAppear {
                        if taskTitle.isEmpty {
                            taskTitle = task.taskTitle
                        }
                    }
                
                TextField("Task Description", text: $taskDescription)
//                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .foregroundStyle(.black)
                    .onSubmit {
                        /// If TaskTitle is Empty, Then Deleting the Task!
                        /// You can remove this feature, if you don't want to delete the Task even after the TextField is Empty
                        if taskDescription == "" {
                            context.delete(task)
                            try? context.save()
                        }
                    }
                    .onChange(of: taskDescription, initial: false) { oldValue, newValue in
                        task.taskDescription = newValue
                    }
                    .onAppear {
                        if taskDescription.isEmpty {
                            taskDescription = task.taskDescription
                        }
                    }
                
                HStack (spacing: 0) {
                    Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("priority: ")
                        .font(.caption)
                        .foregroundStyle(.black)
                        .italic()
                    
//                    Picker("Priority", selection: $task.priority) {
//                        ForEach(Priority.allCases, id: \.self) { priority in
//                            Text(priority.rawValue.capitalized)
//                                .font(.caption)
//                                .foregroundStyle(.black)
//                        }
//                    }
                    Text(task.priority.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.black)
                        .italic()
                }
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .contextMenu {
                Button("Delete Task", role: .destructive) {
                    /// Deleting Task
                    /// For Context Menu Animation to Finish
                    /// If this causes any Bug, Remove it!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        context.delete(task)
                        try? context.save()
                    }
                }
            }
            .offset(y: -8)
        }
    }
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
}

#Preview {
    ContentView()
}
