//
//  ContentView.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 24/06/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game:EmojiMemoryGame;
    
    @State private var dealt = Set<Int>();
    private func deal (_ card:EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    private func isUndealt (_ card:EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    private func dealAnimation (for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            delay=Double(index) * (CardConstants.totalDealDuration/Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment:.bottom){
            VStack{
                gameBody.onAppear{game.shuffle()}
                HStack{
                   shuffle
                    Spacer()
                   restart
                }
                .padding(.horizontal)
            }
            deckBody
        }
       
        
    }
    
    
    
    var gameBody : some View {
        AspectVGrid(items:game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(8)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture{
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }.foregroundColor(CardConstants.color)
    }
    var deckBody : some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)){ card in
                CardView(card:card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .scale, removal: .identity))
            }
        }
        .frame(width:CardConstants.undealWidth, height:CardConstants.undealHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture{
            for card in game.cards {

            withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    var shuffle : some View {
        Button("Shuffle"){
            withAnimation{
                game.shuffle()
            }
            
        }
    }
    var restart : some View {
        Button("Restart"){
            withAnimation{
                dealt = []
                game.restart()
            }
            
        }
    }
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio

    }
    }
 



struct CardView : View {
    let card: EmojiMemoryGame.Card
    @State private var animatedBonusRemaining : Double = 0
    var body : some View{
        GeometryReader { geometry in
                ZStack(){
                    Group{
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 1-animatedBonusRemaining*360-90))
                                .onAppear {
                                    animatedBonusRemaining = card.bonusRemaining
                                    withAnimation(.linear(duration:card.bonusTimeRemaining)) {
                                        animatedBonusRemaining=0
                                    }
                                }
                        } else {
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 1-card.bonusRemaining*360-90))
                        }
                    }
                        .padding(drawingConstants.timerPadding)
                        .opacity(drawingConstants.timerOpacity)
                        Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(.linear(duration:0.8).repeatForever(autoreverses:false), value: card.isMatched)
                        .font(font(size: geometry.size))
                        .scaleEffect(scale(thatFits: geometry.size))
                }.cardify(isFaceUp: card.isFaceUp)
                    }
                }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (drawingConstants.fontSize/drawingConstants.fontScale)
    }
    
    private func font(size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * drawingConstants.contentScaling)
    }
    }
    
    


//We put the constants here so we can reuse them throughout the codebase
    private struct drawingConstants {
        static let borderRadius : CGFloat = 10
        static let lineWidth : CGFloat = 3
        static let contentScaling : CGFloat = 0.7
        static let fontScale : CGFloat = 0.6
        static let fontSize : CGFloat = 46
        static let timerPadding: CGFloat = 5
        static let timerOpacity: CGFloat = 0.5
    }

    extension View {
        func cardify(isFaceUp:Bool) -> some View{
            self.modifier(Cardify(isFaceUp: isFaceUp))
        }
    }

  
    
    struct ContentView_Previews: PreviewProvider {
        static let game = EmojiMemoryGame()
        static var previews: some View {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
        }
    }

