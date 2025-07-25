//
//  UnoCardSelector.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoCardSelector: View {
    @ObservedObject var updater = Updater.getInstance()
    
    var currentCard: UnoCard?
    var onPlaceCard: (Int) -> Void
    var cards: [UnoCard]

    var screen = UIScreen.main.bounds
    var sensoryFeedback = SensoryFeedback.getInstance()
    
    @State var lastDragOffset: CGPoint? = nil
    @State var selectedCardIndex: Int?
    @State var startHoldingCardPos: CGSize? = nil
    @State var holdingCardPos: CGSize? = nil
    @State var currentCardHeightOffset: CGFloat = 0

    init(currentCard: UnoCard?, cards: [UnoCard], onPlaceCard: @escaping (Int) -> Void) {
        self.onPlaceCard = onPlaceCard
        self.currentCard = currentCard
        self.cards = cards
        
        
        print(cards.map { "[\($0.char) : \($0.color)]" })
    }

    var body: some View {
        ZStack {
            let cardCount = cards.count
            ForEach(0..<cardCount, id: \.self) { i in
                let card = cards[i]
                let offset = getCardOffset(i)
                
                UnoCardView(card: card, glowing: UnoEngine.canPlaceCardOn(card, topCard: currentCard!))
                    .rotationEffect(.degrees(getRotation(i)), anchor: .bottom)
                    .scaledToFit()
                    .scaleEffect((selectedCardIndex ?? -1 != i) ? 0.5 : (holdingCardPos == nil ? 0.75 : 0.375))
                    .offset(
                        x: offset.width,
                        y: offset.height
                    )
                    .zIndex((selectedCardIndex ?? -1 == i) ? 1 : 0)
            }

            Rectangle()
                .fill(.white.opacity(0.0001))
                .stroke(
                    .white.opacity(0),
                    style: .init(
                        lineWidth: 10,
                        lineCap: .round,
                        dash: [20, 40]
                    )
                )
                .zIndex(2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in dragGuestureChange(value) }
                        .onEnded { value in dragGuestureEnded(value) }
                )
        }.frame(width: screen.width * 0.9, height: screen.height * 0.2)
            .onChange(of: selectedCardIndex) { _, _ in
                sensoryFeedback.impact(.medium)
            }
    }
    
    private func getCardOffset(_ i: Int) -> CGSize {
        var defaultOffset = selectedCardIndex == nil ?
            CGSize(
                width: (Double(i) - (Double(cards.count - 1) / 2.0))
                    * (getPixelsPerCard() * 0.5),
                height: dstToSelected(i) * -20 - (screen.height * 0.05)
            ) :
            CGSize(
                width: (Double(i) - (Double(cards.count - 1) / 2.0))
                      * (getPixelsPerCard() * 1),
                height: dstToSelected(i) * -20 - (screen.height * 0.05)
            )
        
        if selectedCardIndex == i && holdingCardPos != nil {
            let res = CGSize(width: holdingCardPos!.width - startHoldingCardPos!.width, height: holdingCardPos!.height - 100)
            return CGSize(width: res.width + defaultOffset.width, height: res.height)
        }
        
        defaultOffset.width -= (lastDragOffset?.x ?? 0)
        
        return defaultOffset
    }

    private func getPixelsPerCard() -> Double {
        return min((screen.width - 50) / CGFloat(cards.count), 50)
    }

    private func getRotation(_ i: Int) -> Double {
        if selectedCardIndex != nil { return 0 }
        return ((Double(i) + 0.5) / Double(cards.count) - 0.5) * 100
    }

    private func dstToSelected(_ i: Int) -> CGFloat {
        if holdingCardPos != nil { return 0 }
        return 3 / (abs((Double(selectedCardIndex ?? -10) - Double(i))) + 0.5)
    }

    private func dragGuestureChange(_ value: DragGesture.Value) {
        if value.location == lastDragOffset ?? .zero {
            return
        }
        lastDragOffset = value.location
        
        if selectedCardIndex != nil && (value.location.y < 0 || value.velocity.height < -20) {
            if UnoEngine.canPlaceCardOn(cards[selectedCardIndex!], topCard: currentCard!) {
                withAnimation(.easeOut(duration: 0.2)) {
                    if startHoldingCardPos == nil {
                        startHoldingCardPos = value.translation
                    }
                    holdingCardPos = value.translation
                }
            }
        } else {
            withAnimation(.easeOut(duration: 1)) {
                holdingCardPos = nil
                startHoldingCardPos = nil
            }
        }
        
        if abs(value.velocity.height) > abs(value.velocity.height) { return }
        
        if holdingCardPos != nil { return }

        let offsetFromCenter = value.location.x - (screen.width / 2)
        let cardCount = cards.count

        let cardIndex = Int(
            round(
                offsetFromCenter / getPixelsPerCard()
                    + (Double(cardCount - 1) / 2.0)
            )
        )

        if cardIndex < 0 || cardIndex >= cardCount {
            withAnimation(.easeOut(duration: 0.25)) {
                selectedCardIndex = cardIndex < 0 ? 0 : cardCount - 1
            }
            return
        }

        withAnimation(
            .bouncy(
                duration: 0.2,
                extraBounce: 0.2
            )
        ) {
            selectedCardIndex = cardIndex
        }
    }

    private func dragGuestureEnded(_ value: DragGesture.Value) {
        if value.location.y < 0 {
            if !UnoEngine.canPlaceCardOn(cards[selectedCardIndex!], topCard: currentCard!) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    reset()
                }
                return
            }
            onPlaceCard(selectedCardIndex!)
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCardIndex = nil
            }
            reset()
            return
        }
        
        withAnimation(
            .bouncy(
                duration: 0.4,
                extraBounce: 0.2
            )
        ) {
            reset()
        }
    }
    
    private func reset() {
        startHoldingCardPos = nil
        holdingCardPos = nil
        lastDragOffset = nil
        selectedCardIndex = nil
    }
}

#Preview {
    Spacer()
    
    UnoCardSelector(currentCard: UnoCard(color: .GREEN, char: ""), cards: (0..<30).map { _ in
        UnoCard.genRandom()
    }) { _ in }
}
