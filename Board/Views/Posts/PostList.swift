//
//  PostList.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct PostsList: View {
    let posts: [Post]

    var body: some View {
        ScrollView {
            ForEach(posts, id: \.id) {
                PostRow(post: $0)
            }
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        let urls = [
            "https://source.unsplash.com/featured/500x500/?coffee",
            "https://source.unsplash.com/featured/500x500/?water",
            "https://source.unsplash.com/featured/500x500/?table",
            "https://source.unsplash.com/featured/500x500/?person",
            "https://source.unsplash.com/featured/500x500/?forest"
        ].compactMap(URL.init(string:))
        let posts = [
            Post(id: 1, date: Date(), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!]),
            Post(id: 2, date: Date(), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!, URL(string:"https://source.unsplash.com/featured/500x500/?water")!]),
            Post(id: 3, date: Date(), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!, URL(string:"https://source.unsplash.com/featured/500x500/?water")!, URL(string:"https://source.unsplash.com/featured/500x500/?table")!]),
            Post(id: 4, date: Date(), photosUrls: urls)
        ]
        return PostsList(posts: posts)
    }
}
