//
//  BlackJack.swift
//  Carift
//
//  Created by Alice Grace on 11/4/23.
//

class BlackJack: Game {
  private let deck: Deck = .init()

  private var dealerCards: Hand = .init()
  private var playerCards: Hand = .init()

  func tick(isFirstTick: Bool) -> Bool {
    if isFirstTick {
      print("")
      print("Black Jack - Dealer stands at 17\n")
    }

    if self.dealerCards.isEmpty() {
      self.dealerCards.add(cards: [self.deck.draw()!, self.deck.draw()!])
    }
    if self.playerCards.isEmpty() {
      self.playerCards.add(cards: [self.deck.draw()!, self.deck.draw()!])
    }

    let dealerTotal: [Int] = self.dealerCards.blackJackTotals()
    let playerTotal: [Int] = self.playerCards.blackJackTotals()

    self.displayTotals(dealerTotal: dealerTotal, playerTotal: playerTotal, hideDealersFirst: true)

    print("(H)it, (S)tand, (F)old, (Q)uit/(E)xit")
    let userInput: String = Input.get(validInput: ["h", "s", "f", "q", "e"]).lowercased()

    if userInput == "h" {
      return self.hit(dealerTotal: dealerTotal)
    } else if userInput == "s" {
      return self.stand(dealerTotal: dealerTotal, playerTotal: playerTotal)
    } else if userInput == "f" {
      return self.fold()
    } else if userInput == "q" || userInput == "e" {
      return self.quit()
    }

    return true
  }

  private func hit(dealerTotal: [Int]) -> Bool {
    let dealerStanding = self.isDealerStanding(dealerTotal: dealerTotal)

    if !dealerStanding {
      self.dealerCards.add(card: deck.draw()!)
    }

    self.playerCards.add(card: deck.draw()!)

    let newDealerTotal: [Int] = self.dealerCards.blackJackTotals()
    let newPlayerTotal: [Int] = self.playerCards.blackJackTotals()

    let dealerBusted: Bool = newDealerTotal.min()! > 21
    let playerBusted: Bool = newPlayerTotal.min()! > 21

    if playerBusted || dealerBusted {
      self.displayTotals(dealerTotal: newDealerTotal, playerTotal: newPlayerTotal)

      if playerBusted, dealerBusted {
        print("Draw! - Dealer and you busted")
      } else if dealerBusted {
        print("Win! - Dealer busted")
      } else if playerBusted {
        print("Lose! - You busted")
      }

      return self.promptPlayAgain()
    }

    return true
  }

  private func stand(dealerTotal: [Int], playerTotal: [Int]) -> Bool {
    self.displayTotals(dealerTotal: dealerTotal, playerTotal: playerTotal)
    var dealerStanding = self.isDealerStanding(dealerTotal: dealerTotal)

    while !dealerStanding {
      self.dealerCards.add(card: deck.draw()!)

      let newDealerTotal = dealerCards.blackJackTotals()
      dealerStanding = isDealerStanding(dealerTotal: newDealerTotal)

      self.displayTotals(dealerTotal: newDealerTotal, playerTotal: playerTotal)
    }

    let dealerClosestToTwentyOne: Int? = self.dealerCards.blackJackClosestToTwentyOne()
    let playerClosestToTwentyOne: Int? = self.playerCards.blackJackClosestToTwentyOne()

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

    return self.promptPlayAgain()
  }

  private func fold() -> Bool {
    print("Lose! - You folded")
    return self.promptPlayAgain()
  }

  private func quit() -> Bool {
    return false
  }

  func reset() {
    self.dealerCards.clear()
    self.playerCards.clear()
    self.deck.shuffle()
  }

  private func displayTotals(dealerTotal: [Int], playerTotal: [Int], hideDealersFirst: Bool = false)
  {
    if hideDealersFirst {
      let dealerTotalWithoutFirst: [Int] = self.dealerCards.blackJackTotals(withoutFirst: true)
      print("Dealer: ? of ?, \(self.dealerCards.display().dropFirst().joined(separator: ", "))")
      print(
        "Dealer Total(s): ? + \(dealerTotalWithoutFirst.map { String($0) }.joined(separator: ", "))"
      )
    } else {
      print("Dealer: \(self.dealerCards.display().joined(separator: ", "))")
      print("Dealer Total(s): \(dealerTotal.map { String($0) }.joined(separator: ", "))")
    }
    print("")
    print("You: \(self.playerCards.display().joined(separator: ", "))")
    print("Your Totals: \(playerTotal.map { String($0) }.joined(separator: ", "))")
    print("")
  }

  private func isDealerStanding(dealerTotal: [Int]) -> Bool {
    return dealerTotal.max()! >= 17
  }
}
