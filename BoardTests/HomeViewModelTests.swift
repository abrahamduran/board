//
//  HomeViewModelTests.swift
//  BoardTests
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import XCTest
import Combine
@testable import Board

class HomeViewModelTests: XCTestCase {

    private var localRepository: LocalBlogEntriesRepositoryMock!
    private var remoteRepository: RemoteBlogEntriesRepositoryMock!
    private var dependency: HomeViewModel.Dependency!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        localRepository = LocalBlogEntriesRepositoryMock()
        remoteRepository = RemoteBlogEntriesRepositoryMock()
        dependency = .init(remoteRepository: remoteRepository, localRepository: localRepository)
    }

    private func makeSUT() -> HomeViewModel {
        HomeViewModel(dependency: dependency, scheduler: ImmediateScheduler.shared)
    }

    override func tearDown() {
        cancellables = nil
    }

    func test_isLoadingIsTrue_whenViewIsPresented() {
        let sut = makeSUT()

        let recorder = sut.$isLoading
            .asRecorder()

        XCTAssertEqual(recorder.values, [true])
    }

    func test_isLoadingIsFalse_whenViewIsPresented() {
        let sut = makeSUT()

        let recorder = sut.$isLoading
            .asRecorder()

        localRepository.fetchSuccess([])
        remoteRepository.fetchSuccess([])

        XCTAssertEqual(recorder.values, [true, false])
    }

    func test_isRefresh_deletesEntriesFromLocalDB() {
        let sut = makeSUT()

        localRepository.fetchSuccess(BlogEntry.mock())
        remoteRepository.fetchSuccess([])
        sut.isRefreshing = true

        XCTAssertNotNil(localRepository.deleteCompletion)
    }

    func test_whenLocalRepositoryHasData_remoteRepositoryIsNotFetched() {
        let sut = makeSUT()

        localRepository.fetchSuccess(BlogEntry.mock())
        let recorder = sut.$entries
            .asRecorder()

        XCTAssertNil(remoteRepository.fetchCompletion)
        XCTAssertFalse(recorder.events.isEmpty)
    }

    func test_whenLocalRepositoryHasNoData_remoteRepositoryIsFetched() {
        let sut = makeSUT()

        localRepository.fetchSuccess([])
        let recorder = sut.$entries
            .asRecorder()

        XCTAssertNotNil(remoteRepository.fetchCompletion)
        XCTAssertFalse(recorder.events.isEmpty)
    }
}

final class TestableRecorder<Input, Failure: Error> {
    private(set) var events: [Event] = []
    private var cancellables = Set<AnyCancellable>()

    enum Event {
        case value(Input)
        case completion(Subscribers.Completion<Failure>)
    }

    var values: [Input] {
        events.compactMap {
            switch $0 {
            case let .value(value):
                return value
            case .completion:
                return nil
            }
        }
    }

    init<P: Publisher>(_ publisher: P) where P.Output == Input, P.Failure == Failure {
        publisher.sink(
            receiveCompletion: { [unowned self] in self.events.append(.completion($0)) },
            receiveValue: { [unowned self] in self.events.append(.value($0)) }
        )
        .store(in: &cancellables)
    }
}

extension Publisher {
    func asRecorder() -> TestableRecorder<Output, Failure> {
        TestableRecorder(self)
    }
}
