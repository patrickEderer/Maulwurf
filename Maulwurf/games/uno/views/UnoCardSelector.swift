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
    @ObservedObject var engine: UnoEngine
    
    var currentCard: (any UnoCard)?
    var onPlaceCard: (Int) -> Void
    var cards: [any UnoCard]
    var highlightCardFunction: ((any UnoCard) -> Bool)?

    var screen = UIScreen.main.bounds
    var sensoryFeedback = SensoryFeedback.getInstance()
    
    @State var lastDragOffset: CGPoint? = nil
    @State var selectedCardIndex: Int?
    @State var startHoldingCardPos: CGSize? = nil
    @State var holdingCardPos: CGSize? = nil
    @State var currentCardHeightOffset: CGFloat = 0

    init(
        currentCard: (any UnoCard)?,
        cards: [any UnoCard],
        engine: UnoEngine,
        onPlaceCard: @escaping (Int) -> Void,
        highlightCardFunction: ((any UnoCard) -> Bool)? = nil
    ) {
        self.onPlaceCard = onPlaceCard
        self.currentCard = currentCard
        self.cards = cards
        self.engine = engine
        self.highlightCardFunction = highlightCardFunction
    }

    var body: some View {
        ZStack {
            let cardCount = cards.count
            ForEach(0..<cardCount, id: \.self) { i in
                let card = cards[i]
                let offset = getCardOffset(i)
                
                UnoCardView(card: card,
                            glowing: shouldCardGlow(card) ? true : (i == cards.count - 1 && engine.drawCardQueueData != nil ? (shouldCardGlow(card) ? true : nil) : false)
                )
                    .rotationEffect(.degrees(getRotation(i)), anchor: .bottom)
                    .scaledToFit()
                    .scaleEffect(getScaleEffect(i))
                    .offset(
                        x: offset.width,
                        y: offset.height
                    )
                    .zIndex((selectedCardIndex ?? -1 == i) ? 1 : 0)
                    .transition(.blurReplace)
            }.scaleEffect(engine.showCardSelectorHighlighted ? 1.125 : 1)
            ZStack {
                UnoCardView(card: UnoCardBackside(), glowing: !engine.playerHasDrawn)
                    .scaledToFit()
                    .opacity(engine.showCardSelectorHighlighted ? 0 : 1)
                    .scaleEffect(engine.showCardSelectorHighlighted ? 0 : 0.5)
                    .offset(
                        x: screen.width / 2 - 50,
                        y: screen.height * -0.3
                    )
                    .onTapGesture {
                        if engine.showCardSelectorHighlighted { return }
                        if !engine.playerHasDrawn {
                            engine.drawCards(indexOffset: 0, 1, reason: .DRAWING)
                            withAnimation(.easeOut(duration: 0.25)) {
                                engine.playerHasDrawn = true
                            }
                        }
                    }
                
                if engine.drawCardQueueData != nil {
                    let _ = print(engine.drawCardQueueData!.2)
                    Text("\(engine.drawCardQueueData!.2)")
                        .offset(
                            x: screen.width / 2 - 50,
                            y: screen.height * -0.2
                        )
                }
                
                if engine.playerHasDrawn {
                    Button {
                        engine.nextPlayer()
                        engine.endTurn()
                    } label: {
                        Text("Pass")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 80, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(engine.showCardSelectorHighlighted ? .gray.opacity(0.5) : .white)
                                    .stroke(Color(hex: "#00FFFF"), lineWidth: 1)
                            )
                    }.disabled(engine.userInputDisabled)
                        .offset(
                            x: screen.width / 2 - 50,
                            y: screen.height * -0.4
                        )
                }
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
    
    private func getScaleEffect(_ i: Int) -> Double {
        if engine.sortingAnimation { return 1.25 }
        if i == cards.count - 1 && engine.drawCardQueueData != nil { return engine.drawCardQueueData!.1 == .Big ? 1.75 : -0.25 }
        return (selectedCardIndex ?? -1 != i) ? 0.75 : (holdingCardPos == nil ? 1 : 0.5)
    }
    
    private func shouldCardGlow(_ card: any UnoCard) -> Bool {
        if highlightCardFunction != nil {
            return highlightCardFunction!(card)
        }
        return card.canBePlacedOn(currentCard!)
    }
    
    private func getCardOffset(_ i: Int) -> CGSize {
        var defaultOffset: CGSize
        
        if engine.sortingAnimation {
            return CGSize(width: 0, height: -(screen.height * 0.05))
        }
        
        if i == cards.count - 1 && engine.drawCardQueueData != nil {
            if engine.drawCardQueueData!.1 == .Deck {
                return CGSize(
                    width: screen.width / 2 - 50, height: screen.height * -0.3
                )
            } else {
                return CGSize(
                    width: 0, height: screen.height * -0.4
                )
            }
        }
        
        let cardCount = cards.count - (engine.drawCardQueueData == nil ? 0 : 1)
        
        if selectedCardIndex == nil || holdingCardPos != nil {
            defaultOffset = CGSize(
                width: (Double(i) - (Double(cardCount - 1) / 2.0)) * getPixelsPerCard(),
                height: -(screen.height * 0.05)
            )
        } else {
            defaultOffset = CGSize(
                width: (Double(i) - (Double(cardCount - 1) / 2.0)) * getPixelsPerCard(),
                height: (3 / dstToSelected(i)) * -20 - (screen.height * 0.05)
            )
        }
        
        if selectedCardIndex == i && holdingCardPos != nil {
            let res = CGSize(width: holdingCardPos!.width - startHoldingCardPos!.width, height: holdingCardPos!.height - 100)
            return CGSize(width: res.width + defaultOffset.width, height: res.height)
        }
        
        return defaultOffset
    }

    private func getPixelsPerCard() -> Double {
        let cardCount = cards.count - (engine.drawCardQueueData == nil ? 0 : 1)
        return min((screen.width - 150) / CGFloat(cardCount), 50)
    }

    private func getRotation(_ i: Int) -> Double {
        if engine.sortingAnimation { return 0 }
        if i == cards.count - 1 && engine.drawCardQueueData != nil { return 0 }
        if selectedCardIndex != nil {
            return (Double(i - (selectedCardIndex ?? 0)) / Double(cards.count)) * 50
        }
        return ((Double(i) + 0.5) / Double(cards.count) - 0.5) * 50
    }

    private func dstToSelected(_ i: Int) -> CGFloat {
        if holdingCardPos != nil { return 0 }
        if selectedCardIndex == nil { return 0 }
        return abs((Double(selectedCardIndex!) - Double(i))) + 0.5
    }

    private func dragGuestureChange(_ value: DragGesture.Value) {
        if value.location == lastDragOffset ?? .zero {
            return
        }
        lastDragOffset = value.location
        
        if selectedCardIndex != nil &&
            ((value.location.y < 0) ||
             (value.location.y > 0 && abs(value.velocity.height) > abs(value.velocity.height) && abs(value.velocity.height) > 1))
        {
            if shouldCardGlow(cards[selectedCardIndex!]) {
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
        
        if abs(value.velocity.width) < abs(value.velocity.height) { return }
        
        if holdingCardPos != nil { return }

        let offsetFromCenter = value.location.x - (screen.width / 2) + 20
        let cardCount = cards.count

        let cardIndex = Int(
            round(
                offsetFromCenter / getPixelsPerCard()
                    + (Double(cardCount - 1) / 2.0)
                    + (10 / getPixelsPerCard())
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
        if value.location.y < -20 {
            if !shouldCardGlow(cards[selectedCardIndex!]) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    reset()
                }
                return
            }
            onPlaceCard(selectedCardIndex!)
//            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCardIndex = nil
//            }
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
    
    let _ = UnoEngine.getInstance().start()
    UnoCardSelector(currentCard: UnoCardService.getInstance().drawCard(), cards: (0..<10).map { _ in
        UnoCardService.getInstance().drawCard()
    }, engine: UnoEngine.getInstance()) { _ in }
}
