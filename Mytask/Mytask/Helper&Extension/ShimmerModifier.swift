//
//  ShimmerModifier.swift
//  Mytask
//
//  Created by Vineet Rai on 16-Mar-25.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var isShimmering = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray.opacity(0.3),
                                Color.gray.opacity(0.5),
                                Color.gray.opacity(0.3)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 2)
                        .offset(x: isShimmering ? geometry.size.width : -geometry.size.width)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: isShimmering
                        )
                    }
                }
                .mask(content)
            )
            .onAppear {
                isShimmering = true
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

struct TaskRowPlaceholder: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.clear)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.clear)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
