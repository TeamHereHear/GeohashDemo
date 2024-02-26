//
//  DIContainer.swift
//  GeoHashDemo
//
//  Created by Martin on 2/23/24.
//

import Foundation

final class DIContainer: ObservableObject {
    var service: ServiceInterface
    
    init(service: ServiceInterface) {
        self.service = service
    }
    
    
}
