//
//  PlayerTransferList.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 24.05.2022.
//

import SwiftUI

struct PlayerTransferList: View {
    
    @ObservedObject var viewModel: PlayerTransferView.ViewModel
    
    var body: some View {
        List(viewModel.transferQueue, id: \.self) { transfer in
            HStack {
                Circle()
                    .fill(transfer.status == .done ? .green : .orange)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("\(transfer.index)")
                            .bold()
                    )
                Spacer()
                Text(transfer.player.name)
            }
            
        }
    }
}

struct PlayerTransferList_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTransferList(viewModel: .init())
    }
}
