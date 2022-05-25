//
//  UserTellerView.swift
//  Shared
//
//  Created by Marin Novitchi on 20.04.2022.
//

import SwiftUI

struct UserTellerView: View {
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("insert name", text: $name).padding(.horizontal)
                List(Operation.allCases, id: \.self) { operation in
                    NavigationLink {
                        NameResultsView(viewModel: .init(name: name, operation: operation))
                    } label: {
                        Text(operation.rawValue)
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("User teller")
            Text("Select the operation")
        }
    }
}

struct UserTellerView_Previews: PreviewProvider {
    static var previews: some View {
        UserTellerView()
    }
}
