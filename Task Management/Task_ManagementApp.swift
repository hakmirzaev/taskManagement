//
//  Task_ManagementApp.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 07/07/23.
//

import SwiftUI
import Intents

@main
struct Task_ManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
        }
        .modelContainer(for: Task.self)
    }
}
