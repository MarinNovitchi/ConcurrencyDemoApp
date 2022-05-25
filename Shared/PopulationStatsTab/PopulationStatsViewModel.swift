//
//  PopulationStatsViewModel.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 04.05.2022.
//

import Foundation

extension PopulationStatsView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var entries = [PopulationData]()
        static let fetcher = DataFetcher()
        
        func clearPopulationData() {
            if !entries.isEmpty {
                entries = []
            }
        }
        
        func loadOlderPopulationData() async {
            do {
                clearPopulationData()
                let years = [2012, 2013, 2014, 2015]
                entries = try await withThrowingTaskGroup(of: [PopulationData].self) { group -> [PopulationData] in
                    for year in years {
                        group.addTask {
                            try await Task.sleep(nanoseconds: 4_000_000_000)
                            let url = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population&year=\(year)")!
                            let stats: PopulationStatistics = try await Self.fetcher.fetchData(from: url)
                            return stats.data
                        }
                    }
                    let allStories = try await group.reduce(into: [PopulationData]()) { $0 += $1 }
                    return allStories.sorted { $0.Year > $1.Year }
                }
            } catch {
                print("Failed to load population data: \(error.localizedDescription)")
            }
        }
        
        func loadNewPopulationData() async {
            do {
                clearPopulationData()
                let years = [2016, 2017, 2018, 2019]
                entries = try await withThrowingTaskGroup(of: [PopulationData].self) { group -> [PopulationData] in
                    for year in years {
                        group.addTask {
                            let url = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population&year=\(year)")!
                            let stats: PopulationStatistics = try await Self.fetcher.fetchData(from: url)
                            return stats.data
                        }
                    }
                    for try await result in group {
                        if result.isEmpty {
                            group.cancelAll()
                        } else {
                            entries.append(contentsOf: result)
                        }
                    }
                    return entries.sorted { $0.Year > $1.Year }
                }
            } catch {
                print("Failed to load population data: \(error.localizedDescription)")
            }
        }
    }
}
