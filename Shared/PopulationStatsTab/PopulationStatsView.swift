//
//  PopulationStatsView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 25.04.2022.
//

import SwiftUI

struct PopulationStatsView: View {
    
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            Button("Refresh") {
                Task {
                    await viewModel.loadNewPopulationData()
                }
            }
            List(viewModel.entries, id: \.Year) { entry in
                VStack(alignment: .leading) {
                    Text(entry.Year)
                        .font(.headline)
                    Text(String(entry.Population))
                }
            }
            .refreshable {
                await viewModel.loadNewPopulationData()
            }
            .navigationTitle("US Population stats")
        }
        .task {
            await viewModel.loadOlderPopulationData()//that task will automatically be canceled when the view disappears.
        }
    }
}

struct PopulationStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PopulationStatsView(viewModel: .init())
    }
}
