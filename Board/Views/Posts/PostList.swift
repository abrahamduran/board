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
        VStack {
            ForEach(posts) {
                PostRow(post: $0)
            }
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        return PostsList(posts: Post.preview)
    }
}
