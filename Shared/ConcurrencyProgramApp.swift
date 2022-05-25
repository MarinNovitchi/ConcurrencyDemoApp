//
//  ConcurrencyProgramApp.swift
//  Shared
//
//  Created by Marin Novitchi on 20.04.2022.
//

import SwiftUI

@main
struct ConcurrencyProgramApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                UserTellerView()
                    .tabItem {
                        Label("User Teller", systemImage: "person.fill.questionmark")
                    }
                PopulationStatsView(viewModel: .init())
                    .tabItem {
                        Label("Population Stats", systemImage: "person.3.fill")
                    }
                PlayerTransferView(viewModel: .init())
                    .tabItem {
                        Label("Player transfer", systemImage: "flag.filled.and.flag.crossed")
                    }
            }
        }
    }
}
