//
//  HomeViewModel.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import Combine
import CombineExt
import SDWebImage

final class HomeViewModel: ObservableObject {
    @Published private(set) var entries = [BlogEntry]()
    @Published private(set) var isLoading = true
    @Published var isRefreshing = false

    struct Dependency {
        let remoteRepository: BlogEntriesRepository
        let localRepository: BlogEntriesRepository & BlogEntriesRepositoryDeletion

        init(remoteRepository: BlogEntriesRepository = RemoteBlogEntriesRepository(),
             localRepository: BlogEntriesRepository & BlogEntriesRepositoryDeletion = LocalBlogEntriesRepository()) {
            self.remoteRepository = remoteRepository
            self.localRepository = localRepository
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init<SchedulerType: Scheduler>(dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        configureIsLoading(scheduler: scheduler)
        configureIsRefreshing(scheduler: scheduler)
        configureRefresh(scheduler: scheduler, dependency: dependency)
        configureEntries(scheduler: scheduler, dependency: dependency)
    }

    private func configureIsLoading<SchedulerType: Scheduler>(scheduler: SchedulerType) {
        $entries
            .dropFirst()
            .map { _ in false }
            .receive(on: scheduler)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }

    private func configureIsRefreshing<SchedulerType: Scheduler>(scheduler: SchedulerType) {
        $entries.map { _ in false }
            .receive(on: scheduler)
            .assign(to: \.isRefreshing, on: self)
            .store(in: &cancellables)
    }

    private func configureRefresh<SchedulerType: Scheduler>(scheduler: SchedulerType, dependency: Dependency) {
        $isRefreshing
            .filter { $0 }
            .map { [unowned self] _ in
                dependency.localRepository
                    .delete(self.entries)
                    .replaceError(with: ())
            }
            .switchToLatest()
            .sink { [weak self] _ in
                self?.configureEntries(scheduler: scheduler, dependency: dependency)
                SDWebImageManager.defaultImageCache?.clear(with: .all, completion: nil)
            }
            .store(in: &cancellables)
    }

    private func configureEntries<SchedulerType: Scheduler>(scheduler: SchedulerType, dependency: Dependency) {
        let localEntries = dependency.localRepository
            .fetch()
            .replaceError(with: [])
            .share(replay: 1)

        let remoteEntries = localEntries
            .filter(\.isEmpty)
            .map { _ in
                dependency.remoteRepository
                    .fetch()
                    .replaceError(with: [])
            }
            .switchToLatest()
            .filter { !$0.isEmpty}
            .handleEvents(receiveOutput: { output in
                dependency.localRepository.save(output, completion: { _ in })
            })
            .share(replay: 1)

        Publishers.Merge(localEntries.filter { !$0.isEmpty }, remoteEntries)
            .delay(for: .seconds(5), scheduler: scheduler)
            .receive(on: scheduler)
            .assign(to: \.entries, on: self)
            .store(in: &cancellables)
    }
}
