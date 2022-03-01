//
//  CancelBag.swift
//
//  Copyright © 2022 ALTEN. All rights reserved.
//

import Combine


/// Almacén que permite retener la suscripción de diferentes suscriptores de Combine
public final class CancelBag {
    public fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    deinit {
        cancel()
    }
    
    /// Elimina todos los sucriptores del almacen. Si los suscriptores no se encuentran retenidos en memoria en algún otro sitio se liberarán de memoria produciendo la desuscripción
    public func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    /// Permite almacenar un suscriptor de Combine en un almacen de tipo `CancelBag`
    /// - Parameter cancelBag: Almacen donde se retiene el suscriptor
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
