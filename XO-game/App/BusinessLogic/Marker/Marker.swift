//
//  Marker.swift
//  XO-game
//
//  Created by Artem Kufaev on 05.01.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

// MARK: - Invoker

final class Marker {
    
    // MARK: Singleton
    
    internal static let shared = Marker()
    private init() {
        Marker.queue.maxConcurrentOperationCount = 1
    }
    
    private static let queue = OperationQueue()
    
    // MARK: Private properties
    
    private var commands: [MarkerCommand] = []
    
    // MARK: Internal
    
    internal func addCommand(_ command: MarkerCommand) {
        commands.append(command)
    }
    
    // MARK: Public
    
    public func executeCommands() {
        var firstPlayerCommands = commands.filter { (command) -> Bool in
            return command.mark.player == .first
        }
        var secondPlayerCommadns = commands.filter { (command) -> Bool in
            return command.mark.player == .second
        }
        commands.removeAll()
        guard firstPlayerCommands.count == secondPlayerCommadns.count else { return }
        while (!firstPlayerCommands.isEmpty) {
            let firstCommand = firstPlayerCommands.removeFirst()
            Marker.queue.addOperation {
                firstCommand.execute()
            }
            let secondCommand = secondPlayerCommadns.removeFirst()
            Marker.queue.addOperation {
                secondCommand.execute()
            }
        }
    }
    
    public func wait() {
        Marker.queue.waitUntilAllOperationsAreFinished()
    }
    
}
