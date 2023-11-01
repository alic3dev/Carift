//
//  Hand.swift
//  Carift
//
//  Created by Alice Grace on 10/31/23.
//

import Foundation

class Hand {
  private var cards: [Card] = []

  init() {}

  init(cards: [Card]) {
    self.cards = cards
  }

  func add(card: Card) {
    cards.append(card)
  }

  func add(cards: [Card]) {
    self.cards.append(contentsOf: cards)
  }

  func count() -> Int {
    cards.count
  }

  func isEmpty() -> Bool {
    cards.isEmpty
  }

  func clear() {
    cards.removeAll()
  }

  func display() -> [String] {
    cards.map { $0.display() }
  }

  func blackJackTotals(withoutFirst: Bool = false) -> [Int] {
    var values = [0]

    for card in withoutFirst ? [Card](cards.dropFirst()) : cards {
      let cardValue = card.valueAsPoints()

      values = values.map { value -> Int in value + cardValue }

      if cardValue == 1 {
        values.append(contentsOf: values.map { value -> Int in value + 10 }.filter { value -> Bool in value < 21 })
      }
    }

    return values
  }

  func blackJackClosestToTwentyOne() -> Int? {
    let totals = blackJackTotals().filter { $0 <= 21 }

    return totals.max()
  }
}
