//
//  GeoLocationRepository.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import Foundation
import Combine
import CoreLocation
import Geohash

import FirebaseFirestore


enum DBError: Error {
    case invalidEntity
    case invalidRequest
    case nilSelf
    case custom(Error)
}

protocol GeoLocationRepositoryInterface {
    func add(_ entity: GeoLocationEntity) throws -> GeoLocationEntity
    
    func fetchAround(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double,
        searchingIn geohashArray: [String]
    ) async throws -> [GeoLocationEntity]
}

class GeoLocationRepository: GeoLocationRepositoryInterface {
    let collectionRef = Firestore.firestore().collection("GeoLocation")
    
    func add(_ entity: GeoLocationEntity) throws -> GeoLocationEntity {
        guard let id = entity.id else {
            throw DBError.invalidEntity
        }
        
        do {
            try collectionRef
                .document(id)
                .setData(from: entity)
            
            return entity
        } catch {
            throw DBError.custom(error)
        }
    }
    
    func fetchAround(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double,
        searchingIn geohashArray: [String]
    ) async throws -> [GeoLocationEntity] {
        
        guard let findingLength = geohashArray.first?.count else {
            throw DBError.invalidRequest
        }
        let fieldValue: String = "geoHash\(findingLength)"
        
        let snapshot = try await collectionRef
            .whereField(.init(["location", fieldValue]), in: geohashArray)
            .getDocuments()
        
        let entities = snapshot.documents
            .compactMap {
                try? $0.data(as: GeoLocationEntity.self)
            }
        
        return entities
            .filter {
            let locationOfEntity = CLLocation(latitude: $0.location.lat, longitude: $0.location.long)
            let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            let distanceInM: Double = locationOfEntity.distance(from: centerLocation)
            
            return distanceInM <= radiusInM
        }
    }
}
