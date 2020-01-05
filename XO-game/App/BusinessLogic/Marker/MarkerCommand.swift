//
//  MarkerCommand.swift
//  XO-game
//
//  Created by Artem Kufaev on 05.01.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

// MARK: - Command

final class MarkerCommand {
    
    let mark: (player: Player, position: GameboardPosition)
    let gameboard: Gameboard
    let gameboardView: GameboardView
    let markView: MarkView
    
    init(player: Player,
         position: GameboardPosition,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         markView: MarkView) {
        self.mark = (player, position)
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markView = markView
    }
    
    func execute() {
        let mark = self.mark
        self.gameboard.setPlayer(mark.player, at: mark.position)
        DispatchQueue.main.async {
            self.gameboardView.removeMarkView(at: mark.position)
            self.gameboardView.placeMarkView(self.markView, at: mark.position)
        }
        usleep(500_000)
    }
    
}
