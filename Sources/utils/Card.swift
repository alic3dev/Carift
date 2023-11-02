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
    if value == 1 {
      return "Ace"
    }

    if value > 10 {
      switch value {
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

    return String(value)
  }

  func valueAsPoints() -> Int {
    if value > 10 {
      return 10
    }

    return value
  }

  func display() -> String {
    return "\(valueAsString()) of \(suit)s"
  }
}
