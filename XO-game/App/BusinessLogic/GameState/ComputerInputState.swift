//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Artem Kufaev on 05.01.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class ComputerInputState: PlayerInputState {
    
    override public func begin() {
        super.begin()
        setRandomMark()
    }
    
    private func setRandomMark() {
        guard let gameboardView = gameboardView else { return }
        while (!self.isCompleted) {
            let column = Int.random(in: 0..<GameboardSize.columns)
            let row = Int.random(in: 0..<GameboardSize.rows)
            let position = GameboardPosition(column: column, row: row)
            gameboardView.onSelectPosition?(position)
        }
    }
    
}
