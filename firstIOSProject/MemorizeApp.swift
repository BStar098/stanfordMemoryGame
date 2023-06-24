//
//  firstIOSProjectApp.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 24/06/2023.
//

import SwiftUI
@main
struct firstIOSProjectApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
