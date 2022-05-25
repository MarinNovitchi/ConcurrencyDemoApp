//
//  OriginDetailView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 29.04.2022.
//

import SwiftUI

struct OriginDetailView: View {
    
    let country: CountryProbability
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView(value: country.probability) {
                Text(country.country_id)
            }
        } else {
            HStack {
                Text(country.country_id)
                Text("\(country.probability)")
            }
        }
    }
}

struct OriginDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OriginDetailView(country: CountryProbability(country_id: "UK", probability: 0.77))
    }
}
