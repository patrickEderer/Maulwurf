//
//  UnoView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoView: View {
    @ObservedObject var engine: UnoEngine
    @ObservedObject var updater = Updater.getInstance()
    var unoColorManager = UnoColorManager.getInstance()

    @State private var ipAddress: String = "localhost"
    @State private var unlockPercent: Double = 0.0
    @State private var directionsShowingFlipped: Bool = false
    @State private var showStopConfirmation: Bool = false
    @State private var cardHistoryDragOffset: Int = 0
    @State private var showHistorySheet = false
    var screen = UIScreen.main.bounds

    var body: some View {
        ZStack {
            if engine.isLocked {
                lockedView
            } else {
                unlockedView
            }
            VStack {
                HStack {
                    Button {
                        showStopConfirmation = true
                    } label: {
                        Image(systemName: "multiply")
                            .frame(width: 50, height: 50)
                            .scaleEffect(2)
                    }
                    .accentColor(.white)
                    .alert("Stop game?", isPresented: $showStopConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Stop", role: .destructive) {
                            engine.stop()
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    var lockedView: some View {
        ZStack {
            unlockedView.blur(radius: 10)
                .allowsHitTesting(false)
                .colorMultiply(Color(hex: "#AAAAAA"))
            
            VStack {
                HStack {
                    Text("\(engine.getCurrentPlayer().name)")
                        .padding(.top, 50)
                    PlayerIcon(player: engine.getCurrentPlayer(), size: screen.height / 10)
                }
                Image("uno.arrow.left")
                    .interpolation(.none)
                    .scaleEffect(x: (engine.direction == .CounterClockwise) ^ (directionsShowingFlipped) ? 4 : -4, y: 4, anchor: .center)
                    .onTapGesture {directionsShowingFlipped.toggle()}
                Spacer()
            }
            
            UnoLockButton {
                DispatchQueue.main.sync {
                    engine.unlock()
                }
            }.scaleEffect(0.5)
        }
    }
    
    private func startUpdateThread() {
        unlockPercent = 1.0 / 60.0
        Thread {
            while unlockPercent < 1 && unlockPercent != 0 {
                unlockPercent += 1.0 / 60.0
                Thread.sleep(forTimeInterval: 1.0 / 60.0)
            }
        }.start()
    }
    
    var unlockedView: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                
                UnoOtherPlayersView(engine: engine)
                    .background(
                        ZStack {
                            let highlighted = engine.anyPlayerHasUno()
                            if highlighted {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(hex: "#00FFFF").opacity(engine.pulse ? 0.5 : 1), lineWidth: 10)
                                    .frame(width: screen.width, height: 250)
                                    .blur(radius: 5)
                            }
                            RoundedRectangle(cornerRadius: 50)
                                .fill(highlighted ? Color(hex: "#00FFFF").opacity(0.5).darker(by: engine.pulse ? 0.1 : 0) : .black.opacity(0.25))
                                .frame(width: screen.width, height: 250)
                                .shadow(color: .black, radius: 10)
                        }.padding(.bottom, 50)
                    )
                
                Spacer()
            }.ignoresSafeArea(.all)
            
            topCardView
            
            
            if showingCardUI() {
                AnyView(engine.activeCardUI!)
            }
            else {
                VStack {
                    Spacer()
                    
                    VStack {
                        if engine.isLocked {
                            UnoCardSelector(
                                currentCard: engine.getTopCard(),
                                cards: engine.getPlayer(index: engine.currentPlayerIndex).cards.map { card in
                                    UnoCardBackside()
                                },
                                engine: engine
                            ) { _ in }
                        } else {
                            UnoCardSelector(currentCard: engine.getTopCard(), cards: engine.getPlayer(index: engine.currentPlayerIndex).cards, engine: engine) { i in
                                if engine.cardSelectorInputRedirect == nil {
                                    engine.placeCard(i)
                                } else {
                                    engine.cardSelectorInputRedirect!(i)
                                }
                            }.allowsHitTesting(!(engine.userInputDisabled && !engine.unoButtonPressed))
                        }
                    }
                    .background(
                        ZStack {
                            if engine.showCardSelectorHighlighted {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(hex: "#00FFFF").opacity(1), lineWidth: 10)
                                    .frame(width: screen.width, height: 250)
                                    .blur(radius: 5)
                            }
                            RoundedRectangle(cornerRadius: 50)
                                .fill(engine.showCardSelectorHighlighted ? Color(hex: "#00FFFF").opacity(0.5) : .black.opacity(0.25))
                                .frame(width: screen.width, height: 250)
                                .shadow(color: .black, radius: 10)
                        }
                    )
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            engine.sortCards(playerIndex: engine.currentPlayerIndex)
                        } label: {
                            Text("Sort")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 100, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(engine.showCardSelectorHighlighted ? .gray.opacity(0.5) : .white)
                                        .stroke(.gray, lineWidth: 1)
                                )
                                .frame(width: 100, height: 50)
                        }.disabled(engine.userInputDisabled)
                            .contextMenu {
                                Button {
                                    engine.sortCards(playerIndex: engine.currentPlayerIndex)
                                    engine.getPlayer(index: engine.currentPlayerIndex).autoSort.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: (engine.getPlayer(index: engine.currentPlayerIndex).autoSort ? "circle.fill" : "circle.dotted"))
                                        Text("Auto Sort")
                                    }
                                }
                            }
                        
                        Button {
                            engine.unoButtonPressed.toggle()
                            withAnimation(.bouncy(duration: 0.25, extraBounce: 0.2)) {
                                engine.showCardSelectorHighlighted = engine.unoButtonPressed
                            }
                            
                        } label: {
                            Text("UNO!")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 100, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(engine.showCardSelectorHighlighted ? Color(hex:"#00FFFF") : .white)
                                        .stroke(engine.showCardSelectorHighlighted ? Color(hex:"#00FFFF").opacity(0.5) : .gray, lineWidth: engine.showCardSelectorHighlighted ? 5 : 1)
                                )
                        }.disabled(engine.userInputDisabled && !engine.unoButtonPressed)
                    }
                }
            }
        }.background(Color(hex: engine.showCardSelectorHighlighted ? "#559999" : (engine.drawCardQueueData != nil ? "#55AAAA" : "#AAFFFF")))
    }
    
    func showingCardUI() -> Bool {
        return engine.activeCardUI != nil && engine.getTopCard().hasSpecialPlaceUI()
    }
    
    var topCardView: some View {
        VStack {
            let history = engine.getCardHistory()
            let slideAmount = 10
            ZStack {
                if !history.isEmpty {
                    ForEach (0..<history.count - 1, id: \.self) { i in
                        UnoCardView(card: history[i].0, glowing: history[i].1 == engine.currentPlayerIndex ? nil : false)
                            .rotationEffect(.degrees(Double(max(cardHistoryDragOffset - ((history.count - 1 - i) * slideAmount), 0))), anchor: .bottomLeading)
                            .scaleEffect(0.5)
                    }
                }
                UnoCardView(card: history.last?.0 ?? UnoCardBackside(), glowing: cardHistoryDragOffset != 0 ? (history.last!.1 == engine.currentPlayerIndex ? nil : false) : engine.drawCardQueueData == nil)
                    .rotationEffect(.degrees(Double(max(cardHistoryDragOffset, 0))), anchor: .bottomLeading)
                    .scaleEffect(0.5)
                
                UnoCardView(card: UnoCardBackside2(), glowing: false)
                    .scaleEffect(0.5)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.easeOut(duration: 0.1)) {
                                    if (history.count - 1) * slideAmount < Int(value.translation.height / 2) {
                                        cardHistoryDragOffset = (history.count - 1) * slideAmount
                                    } else {
                                        cardHistoryDragOffset = max(Int(value.translation.height / 2), 0)
                                    }
                                }
                            }
                            .onEnded{ value in
                                withAnimation(.bouncy(duration: 0.25, extraBounce: 0.1)) {
                                    cardHistoryDragOffset = 0
                                }
                            }
                    )
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.25)
                            .onEnded { _ in
                                showHistorySheet.toggle()
                            }
                    )
                    .opacity(0.1)
                    .sheet(isPresented: $showHistorySheet, content: {
                        ScrollView {
                            Spacer()
                                .frame(width: screen.width * 0.75, height: 20)
                            
                            ForEach (0..<history.count, id: \.self) { i_inverted in
                                let i = history.count - 1 - i_inverted
                                UnoCardView(card: history[i].0, glowing: history[i].1 == engine.currentPlayerIndex ? nil : false)
                                    .frame(width: screen.width / 2, height: (screen.width / 2) * 64.0 / 43.0)
                            }
                        }
                    })
            }
        }
    }
}

#Preview {
    let _ = UnoEngine.getInstance().start()
    UnoView(engine: UnoEngine.getInstance())
}
