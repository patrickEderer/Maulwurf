//
//  MainDropDown.swift
//  Gyzz
//
//  Created by Ederer Patrick on 20.05.25.
//

import Foundation
import SwiftUI

struct MainDropDown <Content: View>: View {
    @ObservedObject var manager = DropDownOpenManager.getInstance()
    var id: Int
    var content: () -> Content
    
    var value: String
    var title: String
    
    var color: Color = MaulwurfApp.color
    
    public init(title: String, value: String, id: Int, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.value = value
        self.id = id
    }
    
    var body: some View {
        ZStack {
            let isOpen = manager.getOpenDropDownId() == id
            VStack {
                HStack {
                    Image(systemName: "greaterthan")
                        .foregroundColor(color)
                        .rotationEffect(.degrees(manager.getOpenDropDownId() == id ? 90 : 0))
                    Text("\(title)")
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Text("\(value)")
                }
                VStack {
                    content()
                }
                .padding(10)
                .transition(.blurReplace)
                .frame(maxHeight: isOpen ? nil : 0)
                .padding(.top, isOpen ? 0 : -100)
                .mask(RoundedRectangle(cornerRadius: 10).frame(maxHeight: isOpen ? nil : 0))
                .opacity(isOpen ? 1 : 0)
            }
            .animation(.easeInOut(duration: 0.5), value: manager.getOpenDropDownId() == id)
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .stroke(color, lineWidth: 1)
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .allowsHitTesting(false)
            })
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .gesture(
                TapGesture()
                    .onEnded { value in
                        if manager.getOpenDropDownId() == id {
                            manager.closeAll()
                        } else {
                            manager.openDropDown(id: id)
                        }
                    }
            )
        }
    }
}
