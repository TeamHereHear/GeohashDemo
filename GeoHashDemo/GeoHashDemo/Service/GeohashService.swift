//
//  GeohashService.swift
//  GeoHashDemo
//
//  Created by Martin on 2/23/24.
//

import Foundation
import CoreLocation

import Geohash



protocol GeohashServiceInterface {
    func geohash(for location: CLLocationCoordinate2D) -> String
    
    ///  기준 지점과 그 반경 내부에 걸쳐있는 geohash를 찾는 메서드
    /// - Parameters:
    ///   - center: 기준 지점 좌표
    ///   - radiusInM:  기준 지점으로 부터 반경 (미터단위)
    /// - Returns: 걸쳐있는 geohash들 (optional)
    func overlappedGeohashes(from center: CLLocationCoordinate2D, in radiusInM: Double) -> [String]?
}

class GeohashService: GeohashServiceInterface {
    func geohash(for location: CLLocationCoordinate2D) -> String {
        location.geohash(length: 12)
    }
    
    func overlappedGeohashes(
        from center: CLLocationCoordinate2D,
        in radiusInM: Double
    ) -> [String]? {
        guard let precision = GeohashPrecision.minimumGeohashPrecisionLength(when: radiusInM) else {
            return nil
        }
        // 주변에 접한 8개의 이웃 Geohash
        let neighbors = Geohash.neighbors(geohash: center.geohash(length: precision.rawValue))
        // 정확도를 줄여(길이를 줄여) 해당 geohash가 속해있는 부모 geohash값들을 얻는다.
        // ex) "gcpuv" -> "gcpu"
        let neighborsOfOneStepLowPrecision =  neighbors.map { String($0.prefix(max(1, precision.rawValue - 1))) }
        
        return Array(Set(neighborsOfOneStepLowPrecision))
    }
}

class StubGeohashService: GeohashServiceInterface {
    func geohash(for location: CLLocationCoordinate2D) -> String {
        return "wydm9qwx89"
    }
    
    func overlappedGeohashes(from center: CLLocationCoordinate2D, in radiusInM: Double) -> [String]?  {
        []
    }
}
