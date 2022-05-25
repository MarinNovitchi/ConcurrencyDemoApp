//
//  NameResultsView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 01.05.2022.
//

import SwiftUI

struct NameResultsView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Fetching data using " + viewModel.operation.rawValue)
            GenderDetailView(gender: viewModel.gender)
            ForEach(viewModel.origin.country) { item in
                OriginDetailView(country: item)
            }
            Spacer()
        }
    }
}

struct NameResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NameResultsView(viewModel: .init(name: "Tom", operation: .asyncURLSession))
    }
}
