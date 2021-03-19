//
//  PostRow.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct PostRow: View {
    let post: Post

    var body: some View {
        VStack {
            Text(post.date.shortDateString)
                .font(.body)
            imagesView
        }
    }

    @ViewBuilder private var imagesView: some View {
        switch post.photosUrls.count {
        case 1:
            SingleImageView(url: post.photosUrls[0])
        case 2:
            DoubleImageView(first: post.photosUrls[0], second: post.photosUrls[1])
        case 3:
            TripleImageView(first: post.photosUrls[0], second: post.photosUrls[1], third: post.photosUrls[2])
        default:
            MultipleImagesView(post.photosUrls)
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        let urls = [
            "https://source.unsplash.com/featured/500x500/?coffee",
            "https://source.unsplash.com/featured/500x500/?water",
            "https://source.unsplash.com/featured/500x500/?table",
            "https://source.unsplash.com/featured/500x500/?person",
            "https://source.unsplash.com/featured/500x500/?forest"
        ].compactMap(URL.init(string:))
        let post = Post(id: 1, date: Date(), photosUrls: urls)
        return PostRow(post: post)
    }
}
