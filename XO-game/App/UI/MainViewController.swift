//
//  MainViewController.swift
//  XO-game
//
//  Created by Artem Kufaev on 05.01.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var gameType: GameType!
    
    @IBAction func startGame(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            gameType = .doublePlayers
        case 1:
            gameType = .playerComputer
        case 2:
            gameType = .doublePlayersRandom
        default: break
        }
        goToGameController()
    }
    
    private func goToGameController() {
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? GameViewController else { return }
        controller.setGameType(gameType)
    }

}
