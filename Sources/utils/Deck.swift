//
//  Deck.swift
//  Carift
//
//  Created by Alice Grace on 10/31/23.
//

import Foundation

class Deck {
  private var cards: [Card] = []
  private var discardedCards: [Card] = []

  init() {
    for suit: Suit in Suit.allCases {
      for value: Int in 1...13 {
        self.cards.append(Card(value: value, suit: suit))
      }
    }

    self.shuffle()
  }

  func reset() {
    self.cards.append(contentsOf: self.discardedCards)

    self.discardedCards.removeAll()
  }

  func shuffle(reset: Bool = true) {
    if reset {
      self.reset()
    }

    self.cards.shuffle()
  }

  func draw() -> Card? {
    if self.cards.isEmpty {
      return nil
    }

    let card: Card = self.cards.removeFirst()

    self.discardedCards.append(card)

    return card
  }
}
