//
//  GamesController.swift
//  Carift
//
//  Created by Alice Grace on 11/4/23.
//

class GamesController {
  var isRunning: Bool = true

  private let games: [String] = ["Black Jack"]

  private var selectedGame: Int = 0
  private var runningGame: Game? = nil
  private var isGamesFirstTick: Bool = true

  func promptSelectGame() {
    self.isGamesFirstTick = true
    self.selectedGame = 0

    let exitInputNum: Int = self.games.count + 1

    print(" ♡♤♧♢ Carift ♡♤♧♢ ")
    print("Select a game")

    for i: Int in 1...self.games.count {
      print("\(i)) \(self.games[i - 1])")
    }

    print("\(exitInputNum)) Exit")

    let userInput: String = Input.get(
      validInput: Array(1...exitInputNum).map { String($0) },
      caseSensitive: true
    )

    self.selectedGame = Int(userInput) ?? exitInputNum

    if self.selectedGame == 1 {
      self.runningGame = BlackJack()
    } else {
      self.runningGame = nil
    }
  }

  func tick() {
    if self.selectedGame == 0 {
      self.promptSelectGame()
    }

    if self.selectedGame > 0, self.selectedGame <= self.games.count {
      if !self.runningGame!.tick(isFirstTick: self.isGamesFirstTick) {
        self.promptSelectGame()
      }

      self.isGamesFirstTick = false
    } else {
      self.isRunning = false
    }
  }
}
