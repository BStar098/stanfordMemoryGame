//
//  MemoryGame.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 26/08/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards : Array<Card>
    
    private var onlyFaceUpCardIndex : Int? {
        get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set {cards.indices.forEach{cards[$0].isFaceUp = $0==newValue }}
    }
    
    mutating func choose(_ card: Card){
        if let chosenCardIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenCardIndex].isMatched,
           !cards[chosenCardIndex].isFaceUp
        {
            if let potentialMatchIndex = onlyFaceUpCardIndex {
                if(cards[potentialMatchIndex].content == cards[chosenCardIndex].content){
                    cards[potentialMatchIndex].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                }
                cards[chosenCardIndex].isFaceUp = true

            } else {
                onlyFaceUpCardIndex = chosenCardIndex
               
            }

        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    init (numberOfPairsOfCards:Int, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards x2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card( content: content, id: pairIndex*2))
            cards.append(Card( content: content, id: (pairIndex*2)+1))

        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content:CardContent
        let id: Int
    }

    
  
}

extension Array {
    var oneAndOnly:Element? {
        if(self.count==1){
            return self.first
        } else {
            return nil
        }
    }
}
