//
//  Services.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import Foundation

protocol ServiceInterface {
    var geoLocationService: GeoLocationServiceInterface { get set }
    var geohashService: GeohashServiceInterface { get set }
}

class Service: ServiceInterface {
    var geoLocationService: GeoLocationServiceInterface
    var geohashService: GeohashServiceInterface
    
    init() {
        self.geoLocationService = GeoLocationService(repository: GeoLocationRepository())
        self.geohashService = GeohashService()
    }
}

class StubService: ServiceInterface {
    var geoLocationService: GeoLocationServiceInterface = StubGeoLocationService()
    var geohashService: GeohashServiceInterface = StubGeohashService()
}
