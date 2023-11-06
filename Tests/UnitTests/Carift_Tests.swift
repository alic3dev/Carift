//
//  Carift_Tests.swift
//  Carift-Tests
//
//  Created by Alice Grace on 11/2/23.
//

import XCTest

@testable import Carift

final class Card_Tests: XCTestCase {
  func testValueAsPoints() {
    let cards: [Card] = [
      Card(value: 1, suit: Suit.Heart),
      Card(value: 2, suit: Suit.Diamond),
      Card(value: 10, suit: Suit.Spade),
      Card(value: 11, suit: Suit.Diamond),
      Card(value: 12, suit: Suit.Spade),
      Card(value: 13, suit: Suit.Club),
    ]

    XCTAssertEqual(cards.map { $0.valueAsPoints() }, [1, 2, 10, 10, 10, 10])
  }

  func testValueAsString() {
    let cards: [Card] = [
      Card(value: 1, suit: Suit.Diamond),
      Card(value: 2, suit: Suit.Heart),
      Card(value: 10, suit: Suit.Diamond),
      Card(value: 11, suit: Suit.Spade),
      Card(value: 12, suit: Suit.Diamond),
      Card(value: 13, suit: Suit.Club),
      Card(value: 14, suit: Suit.Heart),
    ]

    XCTAssertEqual(
      cards.map { $0.valueAsString() },
      ["Ace", "2", "10", "Jack", "Queen", "King", "Unknown"]
    )
  }

  func testDisplay() {
    let cards: [Card] = [
      Card(value: 1, suit: Suit.Diamond),
      Card(value: 2, suit: Suit.Heart),
      Card(value: 11, suit: Suit.Spade),
      Card(value: 10, suit: Suit.Club),
      Card(value: 11, suit: Suit.Diamond),
      Card(value: 12, suit: Suit.Heart),
      Card(value: 13, suit: Suit.Spade),
      Card(value: 14, suit: Suit.Club),
    ]

    XCTAssertEqual(
      cards.map { $0.display() },
      [
        "Ace of Diamonds",
        "2 of Hearts",
        "Jack of Spades",
        "10 of Clubs",
        "Jack of Diamonds",
        "Queen of Hearts",
        "King of Spades",
        "Unknown of Clubs",
      ])
  }
}

final class Deck_Tests: XCTestCase {
  var deck: Deck = .init()

  override func setUpWithError() throws {
    self.deck = Deck()
  }

  func testDrawsAllCards() {
    for i: Int in 0...54 {
      let card: Card? = self.deck.draw()

      if i < 52 {
        XCTAssertNotNil(card)
      } else {
        XCTAssertNil(card)
      }
    }
  }

  func testShuffles() {
    let card: Card? = self.deck.draw()

    self.deck.shuffle()

    let shuffledCard: Card? = self.deck.draw()

    XCTAssertFalse(
      card?.value == shuffledCard?.value && card?.suit == shuffledCard?.suit
    )

    // FIXME: Deck may shuffle properly but first card would still be the same
    //        1/52 chance
  }

  func testShufflesNoReset() {
    let cards: [Card?] = [self.deck.draw(), self.deck.draw(), self.deck.draw(), self.deck.draw()]

    self.deck.shuffle(reset: false)

    var shuffledCard: Card?

    repeat {
      shuffledCard = self.deck.draw()

      XCTAssertFalse(
        cards.contains {
          $0?.value == shuffledCard?.value && $0?.suit == shuffledCard?.suit
        }
      )
    } while shuffledCard != nil
  }
}

final class Hand_Tests: XCTestCase {
  var deck: Deck = .init()
  var hand: Hand = .init()

  override func setUpWithError() throws {
    self.deck.shuffle()
    self.hand.clear()
  }

  func testAddsSingleCards() {
    let cards: [Card?] = [self.deck.draw(), self.deck.draw(), self.deck.draw(), self.deck.draw()]

    for i: Int in 0...cards.count - 1 {
      self.hand.add(card: cards[i]!)

      XCTAssertEqual(self.hand.count(), i + 1)
    }
  }

  func testAddsCardArrays() {
    let cards: [Card] = [
      self.deck.draw()!, self.deck.draw()!, self.deck.draw()!, self.deck.draw()!,
    ]

    self.hand.add(cards: cards)
    XCTAssertEqual(self.hand.count(), cards.count)

    self.hand.add(cards: cards)
    XCTAssertEqual(self.hand.count(), cards.count * 2)
  }

  func testClears() {
    let cards: [Card] = [
      self.deck.draw()!, self.deck.draw()!, self.deck.draw()!, self.deck.draw()!,
    ]

    self.hand.add(cards: cards)
    XCTAssertEqual(self.hand.count(), cards.count)

    self.hand.clear()
    XCTAssertEqual(self.hand.count(), 0)
  }

  func testInitsWithAndWithoutCards() {
    XCTAssertEqual(self.hand.count(), 0)

    let handWithCards: Hand = .init(cards: [self.deck.draw()!, self.deck.draw()!])

    XCTAssertEqual(handWithCards.count(), 2)
  }

  func testBlackjackTotals() {
    XCTAssertEqual(self.hand.blackJackTotals(), [0])
    XCTAssertEqual(self.hand.blackJackTotals(withoutFirst: true), [0])

    self.hand.add(card: Card(value: 2, suit: Suit.Spade))
    XCTAssertEqual(self.hand.blackJackTotals(), [2])
    XCTAssertEqual(self.hand.blackJackTotals(withoutFirst: true), [0])

    self.hand.add(card: Card(value: 2, suit: Suit.Diamond))
    XCTAssertEqual(self.hand.blackJackTotals(), [4])
    XCTAssertEqual(self.hand.blackJackTotals(withoutFirst: true), [2])

    self.hand.add(card: Card(value: 1, suit: Suit.Heart))
    XCTAssertEqual(self.hand.blackJackTotals(), [5, 15])
    XCTAssertEqual(self.hand.blackJackTotals(withoutFirst: true), [3, 13])

    self.hand.add(card: Card(value: 1, suit: Suit.Club))
    XCTAssertEqual(self.hand.blackJackTotals(), [6, 16])
    XCTAssertEqual(self.hand.blackJackTotals(withoutFirst: true), [4, 14])
  }

  func testBlackJackClosestToTwentyOne() {
    XCTAssertEqual(self.hand.blackJackClosestToTwentyOne(), 0)

    self.hand.add(card: Card(value: 2, suit: Suit.Heart))
    XCTAssertEqual(self.hand.blackJackClosestToTwentyOne(), 2)

    self.hand.add(card: Card(value: 2, suit: Suit.Spade))
    XCTAssertEqual(self.hand.blackJackClosestToTwentyOne(), 4)

    self.hand.add(card: Card(value: 1, suit: Suit.Diamond))
    XCTAssertEqual(self.hand.blackJackClosestToTwentyOne(), 15)
  }

  func testDisplay() {
    self.hand.add(cards: [
      Card(value: 1, suit: Suit.Diamond),
      Card(value: 2, suit: Suit.Heart),
      Card(value: 11, suit: Suit.Spade),
      Card(value: 10, suit: Suit.Club),
      Card(value: 11, suit: Suit.Diamond),
      Card(value: 12, suit: Suit.Heart),
      Card(value: 13, suit: Suit.Spade),
      Card(value: 14, suit: Suit.Club),
    ])

    XCTAssertEqual(
      self.hand.display(),
      [
        "Ace of Diamonds",
        "2 of Hearts",
        "Jack of Spades",
        "10 of Clubs",
        "Jack of Diamonds",
        "Queen of Hearts",
        "King of Spades",
        "Unknown of Clubs",
      ])
  }
}
