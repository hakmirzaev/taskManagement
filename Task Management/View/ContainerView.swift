//
//  ContainerView.swift
//  Task Management
//
//  Created by Bekhruzjon Hakmirzaev on 12/12/24.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Calender", systemImage: "calendar")
                }
            
            TaskProgressView()
                .tabItem {
                    Label("Progress", systemImage: "timelapse")
                }
        }
    }
}

#Preview {
    ContainerView()
}
