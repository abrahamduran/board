//
//  ImageCarouselView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageCarouselView: View {
    let imagesUrls: [URL]

    var onImageTappedAction: ((URL) -> Void)?

    init(imagesUrls: [URL]) {
        self.imagesUrls = imagesUrls
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(imagesUrls, id: \.self) { url in
                    WebImage(url: url)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            onImageTappedAction?(url)
                        }
                }
            }
        }
    }

    func onImageTapped(perform action: @escaping (URL) -> Void ) -> Self {
        var copy = self
        copy.onImageTappedAction = action
        return copy
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        let urls = [
            "https://source.unsplash.com/featured/500x500/?coffee",
            "https://source.unsplash.com/featured/500x500/?water",
            "https://source.unsplash.com/featured/500x500/?table",
            "https://source.unsplash.com/featured/500x500/?person",
            "https://source.unsplash.com/featured/500x500/?forest"
        ].compactMap(URL.init(string:))

        return ImageCarouselView(imagesUrls: urls)
            .frame(height: 160)
            .previewLayout(.sizeThatFits)
    }
}
