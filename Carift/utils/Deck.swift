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
    for suit in Suit.allCases {
      for value in 1 ... 13 {
        cards.append(Card(value: value, suit: suit))
      }
    }
    
    shuffle()
  }
  
  func shuffle(reset: Bool = true) {
    if reset {
      cards.append(contentsOf: discardedCards)
      
      discardedCards.removeAll()
    }
    
    cards.shuffle()
  }
  
  func draw() -> Card? {
    if cards.isEmpty {
      return nil
    }
    
    let card: Card = cards.removeFirst()
    
    discardedCards.append(card)
    
    return card
  }
}
