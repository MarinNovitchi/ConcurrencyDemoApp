//
//  PlayerTransferViewModel.swift
//  ConcurrencyProgram
//
//  Created by Marin Novitchi on 08.05.2022.
//

import Foundation

extension PlayerTransferView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var selectedPlayer: Player?
        @Published var secondsRemaining = 20
        
        var isTimeExpired: Bool {
            secondsRemaining <= 0
        }
        var elapsedTimeText: String {
            isTimeExpired ? "Time expired" : "You have \(secondsRemaining)s left"
        }
        
        @Published var transferQueue = [Transfer]()
        
        @Published var teamA = [Player]()
        @Published var teamB = [Player]()
        let firstTeam: FootballClub
        let secondTeam: FootballClub
        
        init() {
            firstTeam = FootballClub(members: [Player(name: "Adam"), Player(name: "Albert"), Player(name: "Andrew")])
            secondTeam = FootballClub(members: [Player(name: "Ben"), Player(name: "Bob"), Player(name: "Brian")])
        }
        
        func queueUpTransfer() {
            if let selectedPlayer = selectedPlayer {
                transferQueue.append(Transfer(index:transferQueue.endIndex, player: selectedPlayer))
            }
        }
        
        func transfer()  {
            Task {
                await withTaskGroup(of: Void.self) { group -> Void in
                    for transfer in transferQueue {
                        group.addTask {
                            let transferSucceeded = await self.firstTeam.lose(player: transfer.player, to: self.secondTeam)
                            if transferSucceeded {
                                transfer.status = .done
                            }
                        }
                    }
                    await sync()
                }
            }
        }
        
        func sync() async {
            teamA = await firstTeam.players
            teamB = await secondTeam.players
        }
        
        func elapseTime() {
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                transfer()
            }
        }
    }
}
