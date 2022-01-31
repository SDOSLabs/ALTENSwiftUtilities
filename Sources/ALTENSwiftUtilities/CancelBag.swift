//
//  CancelBag.swift
//
//  Copyright © 2021 SDOS. All rights reserved.
//

import Combine

public final class CancelBag {
    public fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    deinit {
        cancel()
    }
    
    public func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
