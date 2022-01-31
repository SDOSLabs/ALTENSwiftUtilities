//
//  ModelDataState.swift
//
//  Copyright © 2021 SDOS. All rights reserved.
//

import Foundation
import Combine

public enum ModelDataState<T, E: Error>: Equatable {
    public static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        default:
            return false
        }
    }
    
    case idle
    case loading
    case loaded(T)
    case error(E)
    
    var elementLoaded: T? {
        switch self {
        case .idle:
            return nil
        case .loading:
            return nil
        case let .loaded(element):
            return element
        case .error:
            return nil
        }
    }
}

extension ModelDataState where T: Equatable {
    public static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let left), .loaded(let right)):
            if left == right {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}

extension ModelDataState where T: Equatable, E: Equatable {
    public static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let left), .loaded(let right)):
            if left == right {
                return true
            } else {
                return false
            }
        case (.error(let left), .error(let right)):
            if left == right {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}

extension ModelDataState where E: Equatable {
    public static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.error(let left), .error(let right)):
            if left == right {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}

extension Publisher {
    public func sinkToState(_ completion: @escaping (ModelDataState<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            switch subscriptionCompletion {
            case .failure(let error):
                completion(.error(error))
            default: break
            }
        }, receiveValue: { value in
            completion(.loaded(value))
        })
    }
}
