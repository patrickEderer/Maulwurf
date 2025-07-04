//
//  PlayerSelector.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct CategorySelector: View {
    @ObservedObject var updater = Updater.getInstance()
    let wordHelper = Words.getInstance()
    var screen = UIScreen.main.bounds
    
    var body: some View {
        let rows = Int(floor(Double(wordHelper.categories.count + 1) / 2.0))
        ScrollView {
            VStack {
                ForEach (0..<rows, id: \.self) { row in
                    HStack {
                        ForEach (0..<2, id: \.self) { column in
                            let index = row * 2 + column
                            if wordHelper.categories.count > index {
                                let category = wordHelper.categories[index]
                                let color = wordHelper.selectedCategories[category]! ? MaulwurfApp.color : .gray
                                VStack {
                                    Text(category)
                                        .fontWeight(.bold)
                                }.background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(wordHelper.selectedCategories[category]! ? MaulwurfApp.color.opacity(0.13) : .white.opacity(0.01))
                                        .stroke(color.darker(by: 0.4), lineWidth: 5)
                                        .frame(width: screen.width / 3, height: screen.width / 3)
                                )
                                .onTapGesture {
                                    wordHelper.toggleCategorySelection(category)
                                    updater.update()
                                }
                                .frame(width: screen.width / 3, height: screen.width / 3)
                            } else {
                                VStack {
                                }
                                .frame(width: screen.width / 3, height: screen.width / 3)
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
    }
}
