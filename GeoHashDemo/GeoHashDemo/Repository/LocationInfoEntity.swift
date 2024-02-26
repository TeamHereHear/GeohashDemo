//
//  LocationInfoEntity.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import Foundation


struct LocationInfoEntity: Codable {
    var lat: Double
    var long: Double
    var geoHashExact: String // 정확한 지오해쉬 (12글자) 거리 오차범위 ±0.000074 km == 74mm
    var geoHash2: String // 지오해쉬 (2글자) 거리 오차범위 ±630 km
    var geoHash3: String // 지오해쉬 (3글자) 거리 오차범위 ±78 km
    var geoHash4: String // 지오해쉬 (4글자) 거리 오차범위 ±20 km
    var geoHash5: String // 지오해쉬 (5글자) 거리 오차범위 ±2.4 km
    var geoHash6: String // 지오해쉬 (6글자) 거리 오차범위 ±0.61 km == 610m
    var geoHash7: String // 지오해쉬 (7글자) 거리 오차범위 ±0.076 km == 76m
    //TODO: 이렇게 로직을 만드려면 주변의 Hear를 찾을 때 최소 얼만큼의 거리부터 탐색을 시작할지 정해야한다.
    
    init?(lat: Double, long: Double, geoHashExact: String) {
        guard geoHashExact.count == 12 else {
            return nil
        }
        
        self.lat = lat
        self.long = long
        self.geoHashExact = geoHashExact
        self.geoHash2 = String(geoHashExact.prefix(2))
        self.geoHash3 = String(geoHashExact.prefix(3))
        self.geoHash4 = String(geoHashExact.prefix(4))
        self.geoHash5 = String(geoHashExact.prefix(5))
        self.geoHash6 = String(geoHashExact.prefix(6))
        self.geoHash7 = String(geoHashExact.prefix(7))
    }
    
    
    
}

extension LocationInfoEntity {
    func toModel() -> LocationInfo {
        .init(geoHash: geoHashExact, lat: lat, long: long)
    }
}
                        
