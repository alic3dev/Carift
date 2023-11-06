//
//  Card.swift
//  Carift
//
//  Created by Alice Grace on 10/31/23.
//

import Foundation

enum Suit: CaseIterable {
  case Heart
  case Spade
  case Club
  case Diamond
}

class Card {
  let suit: Suit
  let value: Int

  init(value: Int, suit: Suit) {
    self.value = value
    self.suit = suit
  }

  func valueAsString() -> String {
    if self.value == 1 {
      return "Ace"
    }

    if self.value > 10 {
      switch self.value {
      case 11:
        return "Jack"
      case 12:
        return "Queen"
      case 13:
        return "King"
      default:
        return "Unknown"
      }
    }

    return String(self.value)
  }

  func valueAsPoints() -> Int {
    if self.value > 10 {
      return 10
    }

    return self.value
  }

  func display() -> String {
    return "\(self.valueAsString()) of \(self.suit)s"
  }
}
