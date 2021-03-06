//
//  PostRow.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct PostRow: View {
    @Environment(\.postRowAction) private var action: PostRowAction?
    @Environment(\.ordinalDateFormatter) private var formatter: OrdinalDateFormatter

    let post: Post

    var title: String {
        formatter.string(from: post.date)
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.body)
            imagesView
        }
    }

    @ViewBuilder private var imagesView: some View {
        switch post.photosUrls.count {
        case 1:
            SingleImageView(url: post.photosUrls[0])
                .onTapGesture {
                    action?.onImageTapped(post.photosUrls[0])
                }
        case 2:
            DoubleImageView(first: post.photosUrls[0], second: post.photosUrls[1])
                .onImageTapped {
                    action?.onImageTapped($0)
                }
        case 3:
            TripleImageView(first: post.photosUrls[0], second: post.photosUrls[1], third: post.photosUrls[2])
                .onImageTapped {
                    action?.onImageTapped($0)
                }
        default:
            MultipleImagesView(post.photosUrls)
                .onImageTapped {
                    action?.onImageTapped($0)
                }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        return PostRow(post: Post.preview.last!)
    }
}
