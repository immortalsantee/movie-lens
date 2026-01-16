//
//  SMAsyncTaskLoader.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

final class SMAsyncTaskLoader {
    private var task: Task<Void, Never>?

    func load(_ operation: @escaping @Sendable () async -> Void) {
        cancel()
        task = Task { await operation() }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    deinit { cancel() }
}
