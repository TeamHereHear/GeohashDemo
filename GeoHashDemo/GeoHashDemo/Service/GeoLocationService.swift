//
//  GeoLocationService.swift
//  GeoHashDemo
//
//  Created by Martin on 2/23/24.
//

import Foundation
import CoreLocation

enum ServiceError: Error {
    case invalidModel
    case custom(Error)
}

protocol GeoLocationServiceInterface {
    func add(_ model: GeoLocation) throws -> GeoLocation
    
    func fetchAround(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double,
        searchingIn geohashArray: [String]
    ) async throws -> [GeoLocation]
}

class GeoLocationService: GeoLocationServiceInterface {
    private let repository: GeoLocationRepositoryInterface
    
    init(repository: GeoLocationRepositoryInterface) {
        self.repository = repository
    }
    
    @discardableResult
    func add(_ model: GeoLocation) throws -> GeoLocation {
        guard let entity = model.toEntity() else {
            throw ServiceError.invalidModel
        }
        return try repository.add(entity).toModel()
    }
    
    func fetchAround(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double,
        searchingIn geohashArray: [String]
    ) async throws -> [GeoLocation] {
        try await repository.fetchAround(
            from: center,
            in: radiusInM,
            searchingIn: geohashArray
        ).map { $0.toModel() }
    }
    
}

class StubGeoLocationService: GeoLocationServiceInterface {
    
    func add(_ model: GeoLocation) throws -> GeoLocation {
        throw ServiceError.invalidModel
    }
    
    func fetchAround(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double,
        searchingIn geohashArray: [String]
    ) async throws -> [GeoLocation] {
        throw ServiceError.invalidModel
    }
}
