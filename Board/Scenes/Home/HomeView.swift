//
//  HomeView.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isModalPresented = false
    @State private var selectedImageUrl: URL?

    var body: some View {
        if viewModel.isLoading {
            ScrollView {
                HomeLoadingView()
                    .padding()
            }
        } else {
            ZStack {
                RefreshScrollView(isRefreshing: $viewModel.isRefreshing) {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.entries) { entry in
                            BlogEntrySection(entry: entry)

                        }
                    }
                    .padding()
                    .environment(\.postRowAction, PostRowAction(onImageTapped: { selectedImageUrl in
                        self.selectedImageUrl = selectedImageUrl
                        self.isModalPresented = true
                    }))
                }
                .blur(radius: self.isModalPresented ? 2 : 0)
                .animation(Animation.easeIn(duration: 1200))

                if isModalPresented {
                    Color.black
                        .opacity(0.8)
                        .animation(.easeIn)
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                FullscreenImageView(
                    isPresented: $isModalPresented,
                    url: selectedImageUrl
                )
                .offset(y: self.isModalPresented ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(blendDuration: 1200))
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
