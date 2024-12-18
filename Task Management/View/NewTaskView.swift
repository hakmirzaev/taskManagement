//
//  ContainerView.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 12/12/24.
//

import SwiftUI

struct NewTaskView: View {
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    /// Model Context For Saving Data
    @Environment(\.modelContext) private var context
    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""
    @State private var priority: Priority = .medium
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "TaskColor 1"
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Online Meeting!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Description")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Meeting description and link to join", text: $taskDescription)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Priority")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            })
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                /// Giving Some Space for tapping
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    let colors: [String] = (1...5).compactMap { index -> String in
                        return "TaskColor \(index)"
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 20, height: 20)
                                .background(content: {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                })
                
            }
            .padding(.top, 5)
            
            Spacer(minLength: 0)
            
            Button(action: {
                /// Saving Task
                let task = Task(taskTitle: taskTitle, taskDescription: taskDescription, creationDate: taskDate, tint: taskColor, priority: priority)
                do {
                    context.insert(task)
                    try context.save()
                    /// After Successful Task Creation, Dismissing the View
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color(taskColor), in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
        })
        .padding(15)
    }
}

#Preview {
    NewTaskView()
        .vSpacing(.bottom)
}
