//
//  UnoCardSelector.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoCardSelector: View {
    var onPlaceCard: () -> Void = { }
    
    var screen = UIScreen.main.bounds
    var sensoryFeedback = SensoryFeedback.getInstance()
    
    @State var debugCardCount = 6
    @State var cards: [UnoCard] = (0..<6).map { _ in UnoCard(color: nil, char: nil) }
    @State var selectedCardIndex: Int?
    @State var holdingCardPos: CGSize? = nil
    
    var body: some View {
        Slider(value: Binding(get: {
            Float(debugCardCount)
        }, set: { new in
            debugCardCount = Int(round(new))
            cards = (0..<debugCardCount).map { _ in UnoCard(color: nil, char: nil) }
        }), in: 1...30)
        Spacer()
        ZStack {
            let cardCount = cards.count
            ForEach (0..<cardCount, id: \.self) { i in
                let card = cards[i]
                UnoCardView(card: card)
                    .rotationEffect(.degrees(getRotation(i)), anchor: .bottom)
                    .scaledToFit()
                    .scaleEffect((selectedCardIndex ?? -1 == i) ? 1.5 : 1)
                    .offset(x: (Double(i) - (Double(cardCount - 1) / 2.0)) * (selectedCardIndex == nil ? getPixelsPerCard() * 0.5 : getPixelsPerCard()), y: dstToSelected(i) * -20)
                    .zIndex((selectedCardIndex ?? -1 == i) ? 1 : 0)
            }
            
            Rectangle()
                .fill(.white.opacity(0.0001))
                .stroke(.white.opacity(0), style: .init(lineWidth: 10, lineCap: .round, dash: [20, 40]))
                .zIndex(2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in dragGuestureChange(value) }
                        .onEnded { value in dragGuestureEnded(value) }
                )
        }.frame(height: screen.height * 0.2)
            .onChange(of: selectedCardIndex) { _, _ in
                sensoryFeedback.impact(.medium)
            }
    }
    
    private func getPixelsPerCard() -> Double {
        return min((screen.width - 100) / CGFloat(debugCardCount), 100)
    }
    
    private func getRotation(_ i: Int) -> Double {
        if selectedCardIndex != nil { return 0 }
        return ((Double(i) + 0.5) / Double(debugCardCount) - 0.5) * 100
    }
    
    private func dstToSelected(_ i: Int) -> CGFloat {
        return 3 / (abs((Double(selectedCardIndex ?? -10) - Double(i))) + 0.5)
    }
    
    private func dragGuestureChange(_ value: DragGesture.Value) {
        if value.location.y < screen.height * -0.1 {
            holdingCardPos = value.translation
            return
        }
        
        let offsetFromCenter = value.location.x - (screen.width / 2)
        let cardCount = cards.count
        
        let cardIndex = Int(round(offsetFromCenter / getPixelsPerCard() + (Double(cardCount - 1) / 2.0)))
        
        if cardIndex < 0 || cardIndex >= cardCount {
            withAnimation(.easeOut(duration: 0.25)) {
                selectedCardIndex = cardIndex < 0 ? 0 : cardCount - 1
            }
            return
        }
        
        withAnimation(.bouncy(duration: selectedCardIndex == nil ? 0.25 : 0.2, extraBounce: 0.2)) {
            selectedCardIndex = cardIndex
        }
    }
    
    private func dragGuestureEnded(_ value: DragGesture.Value) {
        holdingCardPos = nil
        if value.location.y > screen.height * -0.1 {
            withAnimation(.bouncy(duration: 0.35, extraBounce: 0.2)) {
                selectedCardIndex = nil
            }
            return
        }
    }
}

#Preview {
    UnoCardSelector()
}
