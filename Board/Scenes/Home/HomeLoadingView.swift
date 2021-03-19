//
//  HomeLoadingView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct HomeLoadingView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var shimmer = false

    private var badgeSize: CGFloat {
        sizeClass == .compact ? 48 : 80
    }

    private var carouselSize: CGFloat {
        sizeClass == .compact ? 132 : 256
    }

    var body: some View {
        ZStack {
            grayCards
            maskedCards
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmer.toggle()
            }
        }
    }

    var grayCards: some View {
        VStack(spacing: 24) {
            ForEach(0..<3) { _ in
                section(color: UIColor.black.withAlphaComponent(0.09))
            }
        }
    }

    var maskedCards: some View {
        VStack(spacing: 24) {
            ForEach(0..<3) { _ in
                section(color: UIColor.white.withAlphaComponent(0.6))
                    .mask(
                        Rectangle()
                            .fill(Color.white.opacity(0.6))
                            .rotationEffect(.init(degrees: 70))
                            .offset(x: shimmer ? 1000 : -1350)
                            .frame(width: 2000, height: 150)
                    )
            }
        }
    }

    func section(color: UIColor) -> some View {
        VStack() {
            sectionHeader(color: color)
            VStack {
                ForEach(0..<2) { _ in
                    sectionItem(color: color)
                }
            }
        }
    }

    func sectionHeader(color: UIColor) -> some View {
        HStack {
            Color(color)
                .clipShape(Circle())
                .frame(width: badgeSize, height: badgeSize)
            VStack(alignment: .leading) {
                Text("Dr. Darwin Zemlak")
                    .font(.headline)
                    .foregroundColor(.clear)
                    .overlay(Color(color))
                    .disabled(true)
                    .padding(.bottom, 2)
                Text("darwingzemlak@zemlak.com")
                    .font(.body)
                    .foregroundColor(.clear)
                    .overlay(Color(color))
                    .disabled(true)
            }
        }
    }

    func sectionItem(color: UIColor) -> some View {
        Color(color)
            .scaledToFill()
            .clipShape(Rectangle())
    }
}

struct HomeLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLoadingView()
    }
}
