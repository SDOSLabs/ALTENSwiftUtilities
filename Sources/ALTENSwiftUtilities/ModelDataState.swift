//
//  ModelDataState.swift
//
//  Copyright © 2021 SDOS. All rights reserved.
//

import Foundation
import Combine

/// Este enumerador permite representar los estados más comunes en el que podemos encontrarnos una vista. Implementa el protocolo `Equatable` y tiene varias extensiones donde tienen en consideración que los genéricos `T` y `E` también implementan el protocolo `Equatable`. De esta forma es muy fácil realizar la comparación de los estados, ya que sólo necesitaremos usar el operador `==`
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
    
    /// Indica que está "en espera"
    case idle
    
    /// Indica que está cargando
    case loading
    
    /// Indica que ha cargado y proporciona los datos cargados de tipo `T`
    case loaded(T)
    
    /// Indica que ha ocurrido un error y el error producido de tipo `Error`
    case error(E)
    
    
    /// Permite acceder directamente a los datos cargados de tipo `T` si se encuentra en el estado `.loaded(T)`
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
            } else if left != right {
                return false
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
    
    /// Permite suscribirnos a un suscriptor a la vez que transforma la salida al estado `ModelDataState<Output, Failure>`
    /// - Parameter completion: El closure a ejecutar al completarse
    /// - Returns: Un `AnyCancellable` que debe retenerse en memoria para que la suscripción no se libere
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
