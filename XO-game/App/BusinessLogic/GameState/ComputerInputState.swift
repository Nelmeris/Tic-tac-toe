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
        DispatchQueue.global().async {
            self.setRandomMark()
        }
    }
    
    private func setRandomMark() {
        let column = Int.random(in: 0..<GameboardSize.columns)
        let row = Int.random(in: 0..<GameboardSize.rows)
        let position = GameboardPosition(column: column, row: row)
        if (gameboardView!.canPlaceMarkView(at: position)) {
            usleep(1_250_000)
            DispatchQueue.main.async {
                self.gameboardView?.onSelectPosition?(position)
            }
        } else {
            setRandomMark()
        }
    }
    
}
