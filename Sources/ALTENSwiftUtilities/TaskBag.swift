//
//  TaskBag.swift
//  Rafita_app
//
//  Created by rafael.fernandez on 22/12/21.
//  Copyright © 2021 company_app. All rights reserved.
//

import Foundation

@globalActor
public struct TaskBagActor {
    public actor ActorType { }
    public static let shared: ActorType = ActorType()
}

public final class TaskBag<Success, Failure> where Failure : Error {
    fileprivate(set) var subscriptions = Set<Task<Success, Failure>>()
    
    public init() { }
    
    deinit {
        Task {
            await cancel()
        }
    }
    
    @TaskBagActor public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    @TaskBagActor fileprivate func store(_ task: Task<Success, Failure>) {
        guard !subscriptions.contains(task) else { return }
        subscriptions.insert(task)
    }
    
    @TaskBagActor fileprivate func remove(_ task: Task<Success, Failure>) {
        guard subscriptions.contains(task) else { return }
        subscriptions.remove(task)
    }
    
}

extension Task {
    public func execute(in taskBag: TaskBag<Success, Failure>) async throws -> Success {
        await taskBag.store(self)
        do {
            let result = try await self.value
            await taskBag.remove(self)
            return result
        } catch {
            await taskBag.remove(self)
            throw error
        }
    }
}

extension Task where Failure == Never {
    public func execute(in taskBag: TaskBag<Success, Failure>) async -> Success {
        await taskBag.store(self)
        let result = await self.value
        await taskBag.remove(self)
        return result
    }
}
