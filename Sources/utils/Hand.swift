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
    self.cards.append(card)
  }

  func add(cards: [Card]) {
    self.cards.append(contentsOf: cards)
  }

  func count() -> Int {
    return self.cards.count
  }

  func isEmpty() -> Bool {
    return self.cards.isEmpty
  }

  func clear() {
    self.cards.removeAll()
  }

  func display() -> [String] {
    return self.cards.map { $0.display() }
  }

  func blackJackTotals(withoutFirst: Bool = false) -> [Int] {
    var values = [0]

    for card: Card in withoutFirst ? [Card](self.cards.dropFirst()) : self.cards {
      let cardValue = card.valueAsPoints()

      values = values.map { value -> Int in value + cardValue }

      if cardValue == 1 {
        values.append(
          contentsOf:
            values
            .map { (value: Int) -> Int in value + 10 }
            .filter { (value: Int) -> Bool in value < 21 }
        )
      }
    }

    var uniqueValues: [Int] = []
    for i: Int in 0...values.count - 1 {
      if !uniqueValues.contains(values[i]) {
        uniqueValues.append(values[i])
      }
    }

    return uniqueValues
  }

  func blackJackClosestToTwentyOne() -> Int? {
    let totals = blackJackTotals().filter { $0 <= 21 }

    return totals.max()
  }
}
