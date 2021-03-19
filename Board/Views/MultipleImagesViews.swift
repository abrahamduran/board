//
//  MultipleImagesViews.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SingleImageView: View {
    let url: URL

    var body: some View {
        WebImage(url: url)
            .resizable()
            .scaledToFit()
    }
}

struct DoubleImageView: View {
    let first: URL
    let second: URL

    var body: some View {
        HStack {
            WebImage(url: first)
                .resizable()
            WebImage(url: second)
                .resizable()
        }
        .scaledToFit()
    }
}

struct TripleImageView: View {
    let first: URL
    let second: URL
    let third: URL

    var body: some View {
        VStack {
            WebImage(url: first)
                .resizable()
                .scaledToFit()
//                .aspectRatio(1, contentMode: .fill)
            HStack {
                WebImage(url: second)
                    .resizable()
                WebImage(url: third)
                    .resizable()
            }
            .scaledToFit()
        }
    }
}

struct MultipleImagesView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var carouselHeight: CGFloat {
        sizeClass == .compact ? 132 : 256
    }

    let first: URL
    let items: [URL]

    init(_ items: [URL]) {
        let slice = items.dropFirst()
        self.first = items[0]
        self.items = Array(slice)
    }

    var body: some View {
        VStack {
            WebImage(url: first)
                .resizable()
                .scaledToFit()
            ImageCarouselView(imagesUrls: items)
                .frame(height: carouselHeight)
        }
    }
}

struct SingleImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SingleImageView(url: URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!)

            DoubleImageView(
                first: URL(string: "https://source.unsplash.com/featured/500x500/?water")!,
                second: URL(string: "https://source.unsplash.com/featured/500x500/?fruits")!)

            TripleImageView(
                first: URL(string: "https://source.unsplash.com/featured/500x500/?forest")!,
                second: URL(string: "https://source.unsplash.com/featured/500x500/?fire")!,
                third: URL(string: "https://source.unsplash.com/featured/500x500/?mountain")!)

            MultipleImagesView([URL(string: "https://source.unsplash.com/featured/500x500/?animal")!, URL(string: "https://source.unsplash.com/featured/500x500/?ocean")!, URL(string: "https://source.unsplash.com/featured/500x500/?dog")!, URL(string: "https://source.unsplash.com/featured/500x500/?cat")!, URL(string: "https://source.unsplash.com/featured/500x500/?car")!])
                .previewDevice("iPad (8th generation)")
        }
        .previewLayout(.sizeThatFits)
    }
}
