//
//  main.swift
//  Carift
//
//  Created by Alice Grace on 10/31/23.
//

import Foundation

let gamesController: GamesController = .init()
while gamesController.isRunning { gamesController.tick() }

print("Play again soon! :)")
