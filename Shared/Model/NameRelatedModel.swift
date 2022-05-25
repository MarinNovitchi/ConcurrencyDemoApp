//
//  NameRelatedModel.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 20.04.2022.
//

//https://api.nationalize.io/?name=name
struct NameOrigin: Codable {
    let name: String
    let country: [CountryProbability]
}

struct CountryProbability: Codable, Identifiable {
    let country_id: String
    let probability: Double
    
    var id: String { country_id }
}


//https://api.genderize.io/?name=name
struct NameGender: Codable {
    let name: String
    let gender: String
    let probability: Double
    let count: Int
}
