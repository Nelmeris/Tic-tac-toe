//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            statesPassed += 1
            self.currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    private lazy var gameType: GameType = .playerComputer
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    public func setGameType(_ type: GameType) {
        self.gameType = type
    }
    
    private func goToFirstState() {
        statesPassed = 0
        let player = Player.first
        switch gameType {
        case .doublePlayers:
        self.currentState = PlayerInputState(player: player,
                                             markViewPrototype: player.markViewPrototype,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
        case .doublePlayersRandom:
        self.currentState = RandomPlayerInputState(player: player,
                                             markViewPrototype: player.markViewPrototype,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
        case .playerComputer:
        self.currentState = PlayerInputState(player: player,
                                             markViewPrototype: player.markViewPrototype,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
        }
    }
    
    var statesPassed = 0
    
    private func isEndState() -> Bool {
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return true
        }
        return false
    }
    
    private func changeStateToRandomPlayer() {
        guard let playerInputState = currentState as? RandomPlayerInputState else { return }
        let player = playerInputState.player.next
        currentState = RandomPlayerInputState(player: player,
                                              markViewPrototype: player.markViewPrototype,
                                              gameViewController: self,
                                              gameboard: gameboard,
                                              gameboardView: gameboardView)
    }

    private func goToNextState() {
        if gameType == .doublePlayersRandom {
            if statesPassed % 2 == 0, statesPassed != 0 {
                gameboard.clear()
                gameboardView.clear()
                Marker.shared.executeCommands()
                DispatchQueue.global().async {
                    Marker.shared.wait()
                    DispatchQueue.main.async {
                        if self.isEndState() { return }
                        self.changeStateToRandomPlayer()
                    }
                }
            } else {
                changeStateToRandomPlayer()
            }
            return
        }
        
        guard !isEndState() else { return }
        
        switch gameType {
        case .playerComputer:
            if let computerInputState = currentState as? ComputerInputState {
                let player = computerInputState.player.next
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
                return;
            }
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                self.currentState = ComputerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            }
        case .doublePlayers:
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            }
        default: break
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)

        goToFirstState()
        gameboard.clear()
        gameboardView.clear()
    }
    
}

