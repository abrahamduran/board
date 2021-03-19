//
//  HomeViewModelPreview.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel(
            dependency: Dependency(remoteRepository: BlogEntriesRepositoryPreview(), localRepository: BlogEntriesRepositoryPreview()),
            scheduler: DispatchQueue.main
        )
    }
}
