//
//  GeoLocationEntity.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import Foundation

struct GeoLocationEntity: Codable {
    var id: String?
    var title: String
    
    var location: LocationInfoEntity
}

extension GeoLocationEntity {
    func toModel() -> GeoLocation {
        .init(
            id: id,
            title: title,
            location: location.toModel()
        )
    }
}

