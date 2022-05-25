//
//  Population.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 24.05.2022.
//

import Foundation

//https://datausa.io/api/data?drilldowns=Nation&measures=Population&year=2018
struct PopulationData: Codable {
    let Nation: String
    let Year: String
    let Population: Int
}

struct PopulationStatistics: Codable {
    let data: [PopulationData]
}

enum AppErrors: Error {
    case networkIssue, badURL, decodingError, unknown
}
