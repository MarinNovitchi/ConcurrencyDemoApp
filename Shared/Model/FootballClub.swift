//
//  CIBuildView.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 08.05.2022.
//

import SwiftUI

actor FootballClub {
    
    var players: [Player]
    
    init(members: [Player]) {
        players = members
    }
    
    func gain(player: Player) {
        players.append(player)
    }
    
    func lose(player: Player, to rivalClub: FootballClub) async -> Bool {
        guard let index = players.firstIndex(of: player) else { return false }
        let playerToTransfer = players.remove(at: index)
        await rivalClub.gain(player: playerToTransfer)
        return true
    }
}

struct Player: Equatable, Hashable, Identifiable {
    let id = UUID()
    let name: String
}
