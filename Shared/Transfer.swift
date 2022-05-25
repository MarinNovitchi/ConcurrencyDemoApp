//
//  Transfer.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 24.05.2022.
//

enum TransferStatus: String {
    case pending, done
}

class Transfer: Hashable {
    
    init(index: Int, player: Player) {
        self.index = index
        self.player = player
        status = .pending
    }
    
    let index: Int
    let player: Player
    var status: TransferStatus
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(player.id)
    }
    static func == (lhs: Transfer, rhs: Transfer) -> Bool {
        lhs.index == rhs.index
    }
}
