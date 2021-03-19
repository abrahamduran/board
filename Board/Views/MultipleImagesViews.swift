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

    var onImageTappedAction: ((URL) -> Void)?

    var body: some View {
        HStack {
            WebImage(url: first)
                .resizable()
                .onTapGesture {
                    onImageTappedAction?(first)
                }
            WebImage(url: second)
                .resizable()
                .onTapGesture {
                    onImageTappedAction?(second)
                }
        }
        .scaledToFit()
    }

    func onImageTapped(perform action: @escaping (URL) -> Void ) -> Self {
        var copy = self
        copy.onImageTappedAction = action
        return copy
    }
}

struct TripleImageView: View {
    let first: URL
    let second: URL
    let third: URL

    var onImageTappedAction: ((URL) -> Void)?

    var body: some View {
        VStack {
            WebImage(url: first)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    onImageTappedAction?(first)
                }
            HStack {
                WebImage(url: second)
                    .resizable()
                    .onTapGesture {
                        onImageTappedAction?(second)
                    }
                WebImage(url: third)
                    .resizable()
                    .onTapGesture {
                        onImageTappedAction?(third)
                    }
            }
            .scaledToFit()
        }
    }

    func onImageTapped(perform action: @escaping (URL) -> Void ) -> Self {
        var copy = self
        copy.onImageTappedAction = action
        return copy
    }
}

struct MultipleImagesView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var carouselHeight: CGFloat {
        sizeClass == .compact ? 132 : 256
    }

    let first: URL
    let items: [URL]

    var onImageTappedAction: ((URL) -> Void)?

    init(_ items: [URL]) {
        let slice = items.dropFirst()
        self.first = items[0]
        self.items = Array(slice)
    }

    var body: some View {
        VStack {
            WebImage(url: first)
                .resizable()
                .scaledToFill()
                .onTapGesture {
                    onImageTappedAction?(first)
                }
            ImageCarouselView(imagesUrls: items)
                .onImageTapped { onImageTappedAction?($0) }
                .frame(height: carouselHeight)
        }
    }

    func onImageTapped(perform action: @escaping (URL) -> Void ) -> Self {
        var copy = self
        copy.onImageTappedAction = action
        return copy
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
