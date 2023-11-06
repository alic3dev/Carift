//
//  Game.swift
//  Carift
//
//  Created by Alice Grace on 11/4/23.
//

protocol Game {
  func tick(isFirstTick: Bool) -> Bool
  func reset()
  func promptPlayAgain(reset: Bool) -> Bool
}

extension Game {
  func promptPlayAgain(reset: Bool = true) -> Bool {
    print("Play again? (Y)es or (N)o")

    let userInput: String = Input.get(validInput: ["y", "n"])
    let playAgain: Bool = userInput.lowercased() == "y"

    if reset, playAgain {
      self.reset()
    }

    return playAgain
  }
}
