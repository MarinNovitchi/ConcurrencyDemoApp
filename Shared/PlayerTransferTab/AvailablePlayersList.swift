//
//  AvailablePlayersList.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 24.05.2022.
//

import SwiftUI

struct AvailablePlayersList: View {
    
    @ObservedObject var viewModel: PlayerTransferView.ViewModel
    
    #if os(iOS)
    var editMode: EditMode {
        viewModel.isTimeExpired ? .inactive : .active
    }
    #endif
    
    var body: some View {
        #if os(macOS)
        Button("Schedule Transfer") {
            viewModel.queueUpTransfer()
        }
        .disabled(viewModel.isTimeExpired)
        Text(viewModel.elapsedTimeText)
        #endif
        List(selection: $viewModel.selectedPlayer) {
            Section(header: Text("First team")) {
                ForEach(viewModel.teamA, id: \.self) { player in
                    Text(player.name)
                }
            }
            Section(header: Text("Second team")) {
                ForEach(viewModel.teamB, id: \.self) { player in
                    Text(player.name)
                }
            }
        }
        #if os(iOS)
        .environment(\.editMode, .constant(editMode))
        #endif
    }
}

struct AvailablePlayersList_Previews: PreviewProvider {
    static var previews: some View {
        AvailablePlayersList(viewModel: .init())
    }
}
