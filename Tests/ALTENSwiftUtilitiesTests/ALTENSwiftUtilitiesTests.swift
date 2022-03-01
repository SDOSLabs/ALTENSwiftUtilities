import XCTest
@testable import ALTENSwiftUtilities
import Combine

enum TestError: Error {
    case invalidUrl
}

enum TestErrorModelDataState: Error {
    case error1
    case error2
}

enum TestErrorModelDataStateEquatable: Error, Equatable {
    case error1
    case error2
}

struct ObjectModelDataState {
    let id: Int
}

struct ObjectModelDataStateEquatable: Equatable {
    let id: Int
}

final class ALTENSwiftUtilitiesTests: XCTestCase {
    func testCancelBag() {
        let cancelBag = CancelBag()
        CurrentValueSubject<String, Never>("")
            .sink { _ in
                
            }.store(in: cancelBag)
        XCTAssert(cancelBag.subscriptions.count == 1)
        CurrentValueSubject<String, Never>("")
            .sink { _ in
                
            }.store(in: cancelBag)
        XCTAssert(cancelBag.subscriptions.count == 2)
        cancelBag.cancel()
        XCTAssert(cancelBag.subscriptions.count == 0)
    }
    
    func testAlgo() {
        do {
            let model1: ModelDataState<Int, Error> = .loaded(2)
            let model2: ModelDataState<Int, Error> = .loaded(1)
            XCTAssert(model1 != model2)
        }
    }
    
    func testModelDataState() {
        do {
            let model: ModelDataState<Int, Error> = .idle
            XCTAssert(model.elementLoaded == nil)
        }
        do {
            let model: ModelDataState<Int, Error> = .loading
            XCTAssert(model.elementLoaded == nil)
        }
        do {
            let model: ModelDataState<Int, Error> = .loaded(1)
            XCTAssert(model.elementLoaded == 1)
        }
        do {
            let model: ModelDataState<Int, Error> = .error(TestErrorModelDataStateEquatable.error1)
            XCTAssert(model.elementLoaded == nil)
        }
        
        do {
            let expectation = self.expectation(description: "sinkToState")
            
            var bag = Set<AnyCancellable>()
            Just(1).sinkToState{ result in
                let model: ModelDataState<Int, Never> = .loaded(1)
                XCTAssert(result == model)
                expectation.fulfill()
            }.store(in: &bag)
            waitForExpectations(timeout: 5)
        }
        do {
            let expectation = self.expectation(description: "sinkToState Error")
            
            var bag = Set<AnyCancellable>()
            Future<Int, TestErrorModelDataStateEquatable>{ promise in
                promise(.failure(TestErrorModelDataStateEquatable.error1))
            }
                .sinkToState{ result in
                let model: ModelDataState<Int, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
                XCTAssert(result == model)
                expectation.fulfill()
            }.store(in: &bag)
            waitForExpectations(timeout: 5)
        }
        do {
            let expectation = self.expectation(description: "sinkToState Error")
            
            var bag = Set<AnyCancellable>()
            Future<Int, Error>{ promise in
                promise(.failure(TestErrorModelDataStateEquatable.error1))
            }
                .sinkToState{ result in
                let model: ModelDataState<Int, Error> = .error(TestErrorModelDataStateEquatable.error1)
                XCTAssert(result != model)
                expectation.fulfill()
            }.store(in: &bag)
            waitForExpectations(timeout: 5)
        }
        
        do {
            let model1: ModelDataState<Void, Error> = .idle
            let model2: ModelDataState<Void, Error> = .idle
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, Error> = .idle
            let model2: ModelDataState<Int, Error> = .idle
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataStateEquatable> = .idle
            let model2: ModelDataState<Int, TestErrorModelDataStateEquatable> = .idle
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .idle
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .idle
            XCTAssert(model1 == model2)
        }
        
        do {
            let model1: ModelDataState<Void, Error> = .loading
            let model2: ModelDataState<Void, Error> = .loading
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, Error> = .loading
            let model2: ModelDataState<Int, Error> = .loading
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataStateEquatable> = .loading
            let model2: ModelDataState<Int, TestErrorModelDataStateEquatable> = .loading
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .loading
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .loading
            XCTAssert(model1 == model2)
        }
        
        do {
            let model1: ModelDataState<Int, Error> = .loading
            let model2: ModelDataState<Int, Error> = .idle
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, Error> = .loading
            let model2: ModelDataState<ObjectModelDataState, Error> = .idle
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataStateEquatable> = .loading
            let model2: ModelDataState<Int, TestErrorModelDataStateEquatable> = .idle
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .loading
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .idle
            XCTAssert(model1 != model2)
        }
        
        do {
            let model1: ModelDataState<Int, Error> = .loaded(1)
            let model2: ModelDataState<Int, Error> = .loaded(1)
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, Error> = .loaded(1)
            let model2: ModelDataState<Int, Error> = .loaded(2)
            XCTAssert(model1 != model2)
        }
        
        do {
            let model1: ModelDataState<ObjectModelDataStateEquatable, Error> = .loaded(ObjectModelDataStateEquatable(id: 1))
            let model2: ModelDataState<ObjectModelDataStateEquatable, Error> = .loaded(ObjectModelDataStateEquatable(id: 1))
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataStateEquatable, Error> = .loaded(ObjectModelDataStateEquatable(id: 1))
            let model2: ModelDataState<ObjectModelDataStateEquatable, Error> = .loaded(ObjectModelDataStateEquatable(id: 2))
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 1))
            let model2: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 1))
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 1))
            let model2: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 2))
            XCTAssert(model1 != model2)
        }
//        
//        do {
//            let model1: ModelDataState<ObjectModelDataState, Error> = .loaded(ObjectModelDataState(id: 1))
//            let model2: ModelDataState<ObjectModelDataState, Error> = .loaded(ObjectModelDataState(id: 1))
//            XCTAssert(model1 != model2)
//        }
//        do {
//            let model1: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 1))
//            let model2: ModelDataState<ObjectModelDataStateEquatable, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataStateEquatable(id: 2))
//            XCTAssert(model1 != model2)
//        }
//        do {
//            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataState(id: 1))
//            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .loaded(ObjectModelDataState(id: 1))
//            XCTAssert(model1 != model2)
//        }
//        do {
//            let model1: ModelDataState<ObjectModelDataState, Error> = .loaded(ObjectModelDataState(id: 1))
//            let model2: ModelDataState<ObjectModelDataState, Error> = .loaded(ObjectModelDataState(id: 2))
//            XCTAssert(model1 != model2)
//        }
        do {
            let model1: ModelDataState<Int, Error> = .error(TestErrorModelDataStateEquatable.error1)
            let model2: ModelDataState<Int, Error> = .error(TestErrorModelDataStateEquatable.error1)
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            let model2: ModelDataState<Int, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            let model2: ModelDataState<Int, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error2)
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            let model2: ModelDataState<Int, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<Int, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            let model2: ModelDataState<Int, TestErrorModelDataState> = .error(TestErrorModelDataState.error2)
            XCTAssert(model1 != model2)
        }
        
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            XCTAssert(model1 == model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error1)
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataStateEquatable> = .error(TestErrorModelDataStateEquatable.error2)
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            XCTAssert(model1 != model2)
        }
        do {
            let model1: ModelDataState<ObjectModelDataState, TestErrorModelDataState> = .error(TestErrorModelDataState.error1)
            let model2: ModelDataState<ObjectModelDataState, TestErrorModelDataState> = .error(TestErrorModelDataState.error2)
            XCTAssert(model1 != model2)
        }
    }
}
