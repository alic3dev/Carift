//
//  Carift_Tests.swift
//  Carift-Tests
//
//  Created by Alice Grace on 11/2/23.
//

@testable import Carift
import XCTest

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

    XCTAssertEqual(cards.map { $0.display() }, [
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
    deck = Deck()
  }

  func testDrawsAllCards() {
    for i in 0 ... 54 {
      let card: Card? = deck.draw()

      if i < 52 {
        XCTAssertNotNil(card)
      } else {
        XCTAssertNil(card)
      }
    }
  }

  func testShuffles() {
    let card: Card? = deck.draw()

    deck.shuffle()

    let shuffledCard: Card? = deck.draw()

    XCTAssertFalse(
      card?.value == shuffledCard?.value && card?.suit == shuffledCard?.suit
    )

    // FIXME: Deck may shuffle properly but first card would still be the same
    //        1/52 chance
  }

  func testShufflesNoReset() {
    let cards: [Card?] = [deck.draw(), deck.draw(), deck.draw(), deck.draw()]

    deck.shuffle(reset: false)

    var shuffledCard: Card?

    repeat {
      shuffledCard = deck.draw()

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
    deck.shuffle()
    hand.clear()
  }

  func testAddsSingleCards() {
    let cards: [Card?] = [deck.draw(), deck.draw(), deck.draw(), deck.draw()]

    for i in 0 ... cards.count - 1 {
      hand.add(card: cards[i]!)

      XCTAssertEqual(hand.count(), i + 1)
    }
  }

  func testAddsCardArrays() {
    let cards: [Card] = [deck.draw()!, deck.draw()!, deck.draw()!, deck.draw()!]

    hand.add(cards: cards)
    XCTAssertEqual(hand.count(), cards.count)

    hand.add(cards: cards)
    XCTAssertEqual(hand.count(), cards.count * 2)
  }

  func testClears() {
    let cards: [Card] = [deck.draw()!, deck.draw()!, deck.draw()!, deck.draw()!]

    hand.add(cards: cards)
    XCTAssertEqual(hand.count(), cards.count)

    hand.clear()
    XCTAssertEqual(hand.count(), 0)
  }

  func testInitsWithAndWithoutCards() {
    XCTAssertEqual(hand.count(), 0)

    let handWithCards = Hand(cards: [deck.draw()!, deck.draw()!])

    XCTAssertEqual(handWithCards.count(), 2)
  }

  func testBlackjackTotals() {
    XCTAssertEqual(hand.blackJackTotals(), [0])
    XCTAssertEqual(hand.blackJackTotals(withoutFirst: true), [0])

    hand.add(card: Card(value: 2, suit: Suit.Spade))
    XCTAssertEqual(hand.blackJackTotals(), [2])
    XCTAssertEqual(hand.blackJackTotals(withoutFirst: true), [0])

    hand.add(card: Card(value: 2, suit: Suit.Diamond))
    XCTAssertEqual(hand.blackJackTotals(), [4])
    XCTAssertEqual(hand.blackJackTotals(withoutFirst: true), [2])

    hand.add(card: Card(value: 1, suit: Suit.Heart))
    XCTAssertEqual(hand.blackJackTotals(), [5, 15])
    XCTAssertEqual(hand.blackJackTotals(withoutFirst: true), [3, 13])

    hand.add(card: Card(value: 1, suit: Suit.Club))
    XCTAssertEqual(hand.blackJackTotals(), [6, 16])
    XCTAssertEqual(hand.blackJackTotals(withoutFirst: true), [4, 14])
  }

  func testBlackJackClosestToTwentyOne() {
    XCTAssertEqual(hand.blackJackClosestToTwentyOne(), 0)

    hand.add(card: Card(value: 2, suit: Suit.Heart))
    XCTAssertEqual(hand.blackJackClosestToTwentyOne(), 2)

    hand.add(card: Card(value: 2, suit: Suit.Spade))
    XCTAssertEqual(hand.blackJackClosestToTwentyOne(), 4)

    hand.add(card: Card(value: 1, suit: Suit.Diamond))
    XCTAssertEqual(hand.blackJackClosestToTwentyOne(), 15)
  }

  func testDisplay() {
    hand.add(cards: [
      Card(value: 1, suit: Suit.Diamond),
      Card(value: 2, suit: Suit.Heart),
      Card(value: 11, suit: Suit.Spade),
      Card(value: 10, suit: Suit.Club),
      Card(value: 11, suit: Suit.Diamond),
      Card(value: 12, suit: Suit.Heart),
      Card(value: 13, suit: Suit.Spade),
      Card(value: 14, suit: Suit.Club),
    ])

    XCTAssertEqual(hand.display(), [
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
