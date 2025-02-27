//
//  StandardButton.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

struct ButtonView: View {
    let text: String
    let action: () -> Void
    let color: Color
    
    init(text: String, color: Color? = Color.blue, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.color = color!
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(Theme.CornerRadiuses.c12)
        }
        .padding(.horizontal, 20)
    }
}

struct TextView: View {
    let text: String
    let color: Color
    
    init(text: String, color: Color? = Color.blue) {
        self.text = text
        self.color = color!
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(Theme.CornerRadiuses.c12)
        }
        .padding(.horizontal, 20)
    }
}
