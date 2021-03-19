//
//  HomeView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            content
        }
        .padding()
    }

    @ViewBuilder var content: some View {
        if viewModel.isLoading {
            HomeLoadingView()
        } else {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.entries) { entry in
                    BlogEntrySection(entry: entry)
                }
            }
        }
    }
}

struct BlogEntrySection: View {
    let entry: BlogEntry

    var body: some View {
        VStack {
            UserBadgeView(user: entry.user)
            PostsList(posts: entry.posts)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel.preview)
    }
}
