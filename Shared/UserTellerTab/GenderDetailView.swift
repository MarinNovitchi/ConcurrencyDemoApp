//
//  GenderDetailView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 29.04.2022.
//

import SwiftUI

struct GenderDetailView: View {
    
    let gender: NameGender
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView(value: gender.probability) {
                Text(gender.gender)
            }
        } else {
            HStack {
                Text(gender.gender)
                Text("\(gender.probability)")
            }
        }
    }
}

struct GenderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GenderDetailView(gender: NameGender(name: "Lily", gender: "female", probability: 0.85, count: 1500))
    }
}
