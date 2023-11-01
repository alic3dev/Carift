//
//  main.swift
//  Carift
//
//  Created by Alice Grace on 10/31/23.
//

import Foundation

let deck: Deck = .init()

let games: [String] = ["Black Jack"]
var selectedGame: Int?

func printSelectGameInfo() {
  print(" ♡♤♧♢ ♡♤♧♢ ")
  print("Select a game")

  for i in 1 ... games.count {
    print("\(i)) \(games[i - 1])")
  }

  print("\(games.count + 1)) Exit")
}

func selectGame() {
  selectedGame = nil

  printSelectGameInfo()

  while selectedGame == nil {
    print("> ", terminator: "")

    let userInput = Int(readLine() ?? "") ?? 0

    if userInput == 0 || userInput > games.count + 1 {
      print("Invalid input")
      continue
    }

    selectedGame = userInput
  }

  if selectedGame == 1 {
    print("")
    print("Black Jack - Dealer stands at 17\n")
  }
}

selectGame()

var inGame: Bool = true

var dealerCards: Hand = .init()
var playerCards: Hand = .init()

func promptPlayAgain() {
  dealerCards.clear()
  playerCards.clear()
  deck.shuffle()

  print("Play again? (Y)es or (N)o")

  var waitingForValidInput = true

  while waitingForValidInput {
    waitingForValidInput = false
    print("> ", terminator: "")
    let userInput: String = readLine() ?? ""

    if userInput == "N" || userInput == "n" {
      selectGame()
    } else if userInput != "Y", userInput != "y" {
      print("Invalid input")
      waitingForValidInput = true
    }
  }
}

while inGame {
  if selectedGame == 1 {
    if dealerCards.isEmpty() {
      dealerCards.add(cards: [deck.draw()!, deck.draw()!])
    }
    if playerCards.isEmpty() {
      playerCards.add(cards: [deck.draw()!, deck.draw()!])
    }

    var dealerTotal: [Int] = dealerCards.blackJackTotals()
    let playerTotal: [Int] = playerCards.blackJackTotals()

    func isDealerStanding() -> Bool {
      return dealerTotal.max()! >= 17
    }

    var dealerStanding: Bool = isDealerStanding()

    let dealerBusted: Bool = dealerTotal.min()! > 21
    let playerBusted: Bool = playerTotal.min()! > 21

    let dealerAtTwentyOne: Bool = dealerTotal.contains { $0 == 21 }
    let playerAtTwentyOne: Bool = playerTotal.contains { $0 == 21 }

    func displayTotals(hideDealersFirst: Bool = true) {
      if hideDealersFirst {
        let dealerTotalWithoutFirst: [Int] = dealerCards.blackJackTotals(withoutFirst: true)
        print("Dealer: ? of ?, \(dealerCards.display().dropFirst().joined(separator: ", "))")
        print("Dealer Total(s): ? + \(dealerTotalWithoutFirst.map { String($0) }.joined(separator: ", "))")
      } else {
        print("Dealer: \(dealerCards.display().joined(separator: ", "))")
        print("Dealer Total(s): \(dealerTotal.map { String($0) }.joined(separator: ", "))")
      }
      print("")
      print("You: \(playerCards.display().joined(separator: ", "))")
      print("Your Totals: \(playerTotal.map { String($0) }.joined(separator: ", "))")
      print("")
    }

    displayTotals()

    if playerBusted || dealerBusted {
      if playerBusted, dealerBusted {
        print("Draw! - Dealer and you busted")
      } else if dealerBusted {
        print("Win! - Dealer busted")
      } else if playerBusted {
        print("Lose! - You busted")
      }

      promptPlayAgain()
    } else if playerAtTwentyOne || (dealerAtTwentyOne && dealerCards.count() == 2) {
      if playerAtTwentyOne, dealerAtTwentyOne {
        print("Draw! - Both at 21")
      } else if dealerAtTwentyOne {
        print("Lose! - Dealer at 21")
      } else if playerAtTwentyOne {
        print("Win! - You're at 21")
      }

      promptPlayAgain()
    } else {
      print("(H)it, (S)tand, (F)old, (Q)uit/(E)xit")

      var waitingForValidInput = true

      while waitingForValidInput {
        waitingForValidInput = false
        print("> ", terminator: "")
        let userInput: String = readLine() ?? ""

        if userInput == "H" || userInput == "h" {
          if !dealerStanding {
            dealerCards.add(card: deck.draw()!)
          }

          playerCards.add(card: deck.draw()!)
        } else if userInput == "S" || userInput == "s" {
          displayTotals(hideDealersFirst: false)

          while !dealerStanding {
            dealerCards.add(card: deck.draw()!)
            dealerTotal = dealerCards.blackJackTotals()
            dealerStanding = isDealerStanding()

            displayTotals(hideDealersFirst: false)
          }

          let dealerClosestToTwentyOne: Int? = dealerCards.blackJackClosestToTwentyOne()
          let playerClosestToTwentyOne: Int? = playerCards.blackJackClosestToTwentyOne()

          if dealerClosestToTwentyOne == playerClosestToTwentyOne {
            print("Draw!")
          } else if dealerClosestToTwentyOne == nil {
            print("Win! - Dealer busted")
          } else if playerClosestToTwentyOne == nil {
            print("Lose! - You busted")
          } else if dealerClosestToTwentyOne! > playerClosestToTwentyOne! {
            print("Lose! - Dealer closer to 21")
          } else if dealerClosestToTwentyOne! < playerClosestToTwentyOne! {
            print("Win! - You're closer to 21")
          }

          promptPlayAgain()
        } else if userInput == "F" || userInput == "f" {
          print("Lose! - You folded")
          promptPlayAgain()
        } else if userInput == "Q" || userInput == "q" || userInput == "E" || userInput == "e" {
          selectGame()
        } else {
          print("Invalid input")
          waitingForValidInput = true
        }
      }
    }
  } else {
    print("Play again soon! :)")
    inGame = false
  }
}
