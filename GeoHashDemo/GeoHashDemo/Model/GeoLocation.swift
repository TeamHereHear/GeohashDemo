//
//  GeoLocation.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import Foundation
import CoreLocation


struct GeoLocation: Codable, Identifiable, Hashable {
    var id: String?
    var title: String
    
    var location: LocationInfo
}

struct LocationInfo: Codable, Hashable {
    var geoHash: String
    var lat: CLLocationDegrees
    var long: CLLocationDegrees
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: lat, longitude: long)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.geoHash)
    }
}


extension GeoLocation {
    func toEntity() -> GeoLocationEntity? {
        guard let locationEntity = location.toEntity() else {
            return nil
        }
        
        return .init(
            id: id,
            title: title,
            location: locationEntity
        )
    }
}

extension LocationInfo {
    func toEntity() -> LocationInfoEntity? {
        .init(
            lat: lat,
            long: long,
            geoHashExact: geoHash
        )
    }
}
