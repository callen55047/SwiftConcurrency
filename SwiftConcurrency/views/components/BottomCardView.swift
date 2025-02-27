//
//  BottomCard.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-20.
//

import SwiftUI

import SwiftUI

struct BottomCardView<Content: View>: View {
    let bottomSafeArea: CGFloat?
    let content: Content
    let cardHeight: CGFloat
    
    init(@ViewBuilder _ content: () -> Content, _ bottomSafeArea: CGFloat? = nil, cardRatio: CGFloat = Theme.Dimensions.CARD_HEIGHT) {
        self.bottomSafeArea = bottomSafeArea
        self.content = content()
        self.cardHeight = (UIScreen.main.bounds.size.height * cardRatio).rounded()
    }

    var body: some View {
        VerticalContainer {
            content
            if (bottomSafeArea != nil) {
                Spacer().frame(height: bottomSafeArea!)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: cardHeight)
        .background(Color.white)
        .cornerRadius(Theme.CornerRadiuses.c24, corners: [.topLeft, .topRight])
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadiuses.c24)
                .stroke(Color.gray, lineWidth: 1)
                .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadiuses.c24))
        )
    }
}
