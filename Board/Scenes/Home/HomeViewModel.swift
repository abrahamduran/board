//
//  HomeViewModel.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private(set) var entries = [BlogEntry]()
    @Published private(set) var isLoading = true
    @Published private(set) var isRefreshing = false

    struct Input {
        fileprivate let refreshSubject = PassthroughSubject<Void, Never>()
        func refresh() {
            refreshSubject.send()
        }
    }

    let input = Input()

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
    }

    private func configureIsLoading<SchedulerType: Scheduler>(scheduler: SchedulerType) {
        $entries
            .map { _ in false }
            .receive(on: scheduler)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }

    private func configureIsRefreshing<SchedulerType: Scheduler>(scheduler: SchedulerType) {
        Publishers.Merge($entries.map { _ in false }, input.refreshSubject.map { _ in true})
            .receive(on: scheduler)
            .assign(to: \.isRefreshing, on: self)
            .store(in: &cancellables)
    }

    private func configureRefresh<SchedulerType: Scheduler>(scheduler: SchedulerType, dependency: Dependency) {
        input.refreshSubject
            .map { [unowned self] _ in
                dependency.localRepository
                    .delete(self.entries)
            }
            .sink { [weak self] _ in
                self?.configureEntries(scheduler: scheduler, dependency: dependency)
            }
            .store(in: &cancellables)
    }

    private func configureEntries<SchedulerType: Scheduler>(scheduler: SchedulerType, dependency: Dependency) {
        let localEntries = dependency.localRepository
            .fetch()
            .replaceError(with: [])
            .share()

        let remoteEntries = localEntries
            .filter(\.isEmpty)
            .map { _ in
                dependency.remoteRepository
                    .fetch()
                    .replaceError(with: [])
            }
            .switchToLatest()
            .share()

        remoteEntries.sink { output in
            dependency.localRepository.save(output, completion: { _ in })
        }
        .store(in: &cancellables)

        localEntries.merge(with: remoteEntries)
            .filter(\.isEmpty)
            .receive(on: scheduler)
            .assign(to: \.entries, on: self)
            .store(in: &cancellables)
    }
}
