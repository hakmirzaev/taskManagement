//
//  Task.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 08/07/23.
//

import SwiftUI
import SwiftData

enum Priority: String, Codable, CaseIterable {
    case low
    case medium
    case high
}

@Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var taskDescription: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    var priority: Priority
    
    init(id: UUID = .init(), taskTitle: String, taskDescription: String = "", creationDate: Date = .init(), isCompleted: Bool = false, tint: String, priority: Priority = .medium) {
        self.id = id
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
        self.priority = priority
    }
    
    var tintColor: Color {
        switch tint {
        case "TaskColor 1": return .taskColor1
        case "TaskColor 2": return .taskColor2
        case "TaskColor 3": return .taskColor3
        case "TaskColor 4": return .taskColor4
        case "TaskColor 5": return .taskColor5
        default: return .black
        }
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
