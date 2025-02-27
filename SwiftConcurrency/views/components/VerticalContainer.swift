//
//  VerticalContainer.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-20.
//

import SwiftUI

struct VerticalContainer<Content>: View where Content : View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.s0) {
            content
        }
        .padding(.horizontal, Theme.Paddings.p24)
    }
}
