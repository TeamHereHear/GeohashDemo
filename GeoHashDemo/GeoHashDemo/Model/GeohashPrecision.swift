//
//  GeohashPrecision.swift
//  GeoHashDemo
//
//  Created by Martin on 2/24/24.
//

import Foundation

enum GeohashPrecision: Int, CaseIterable {
    case twentyFiveHundredKilometers = 1    // ±2500 km
    case sixHundredThirtyKilometers         // ±630 km
    case seventyEightKilometers             // ±78 km
    case twentyKilometers                   // ±20 km
    case twentyFourHundredMeters            // ±2.4 km
    case sixHundredTenMeters                // ±0.61 km
    case seventySixMeters                   // ±0.076 km
    case nineteenMeters                     // ±0.019 km
    case twoHundredFourtyCentimeters        // ±0.0024 km
    case sixtyCentimeters                   // ±0.00060 km
    case seventyFourMillimeters             // ±0.000074 km
    
    var precisionInM: Double {
        switch self {
        case .twentyFiveHundredKilometers: 2500 * 1000
        case .sixHundredThirtyKilometers: 630 * 1000
        case .seventyEightKilometers: 78 * 1000
        case .twentyKilometers: 20 * 10000
        case .twentyFourHundredMeters: 2400
        case .sixHundredTenMeters: 610
        case .seventySixMeters: 76
        case .nineteenMeters: 19
        case .twoHundredFourtyCentimeters: 2.4
        case .sixtyCentimeters: 0.6
        case .seventyFourMillimeters: 0.0074
        }
    }
    
    
    /// 반경이 Meter 단위로 주어졌을 때 탐색해야하는 최소한의 정확도(Geohash의 길이)를 알 수 있는 메서드
    /// - Parameter radiusInMeter: 탐색하는 반경
    /// - Returns: 최소한의 정확도의 rawValue (Geohash 길이)
    static func minimumGeohashPrecisionLength(when radiusInMeter: Double) -> GeohashPrecision? {
        GeohashPrecision.allCases.first { $0.precisionInM < radiusInMeter }
    }
}
