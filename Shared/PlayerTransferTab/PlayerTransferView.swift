//
//  PlayerTransferView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 07.05.2022.
//

import SwiftUI

struct PlayerTransferView: View {

    @StateObject var viewModel: ViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        NavigationView {
            AvailablePlayersList(viewModel: viewModel)
            PlayerTransferList(viewModel: viewModel)
                .toolbar {
                    #if os(iOS)
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Schedule Transfer") {
                            viewModel.queueUpTransfer()
                        }
                        .disabled(viewModel.isTimeExpired)
                        Text(viewModel.elapsedTimeText)
                    }
                    #endif
                }
                .navigationTitle("Player transfer")
                .task {
                    await viewModel.sync()
                }
                .onReceive(timer) { time in
                    viewModel.elapseTime()
                }
        }
    }
}

struct PlayerTransferView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTransferView(viewModel: .init())
    }
}
