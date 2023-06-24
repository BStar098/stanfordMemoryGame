//
//  EmojiMemoryGame.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 26/08/2023.
//

import SwiftUI



class EmojiMemoryGame : ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis : [String] = ["🍄","🌰","🐀","🐁","🐭","🐹","🐂","🐃","🐄","🐮","🐅","🐆","🐯","🐇","🐰","🐈","🐱","🐎","🐴","🐏","🐑","🐐"]

    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in
            emojis[pairIndex]
        }
    }
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<Card>{
        return model.cards
    }
    
    
    
    // MARK: - Intents()
    func choose(_ card: Card){
        model.choose(card)
    }
    
    func shuffle(){
        model.shuffle()
    }
}
