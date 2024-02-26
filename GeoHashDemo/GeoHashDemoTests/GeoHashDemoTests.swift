//
//  GeoHashDemoTests.swift
//  GeoHashDemoTests
//
//  Created by Martin on 2/24/24.
//

import XCTest
@testable import GeoHashDemo

final class GeoHashDemoTests: XCTestCase {

    func test_주어진반경10KM의필요한최소한의정확도가올바른지() throws {
        // Given
        let radiusInMeter: Double = 10 * 1000
        
        // When
        guard let precision = GeohashPrecision.minimumGeohashPrecisionLength(when: radiusInMeter) else {
            XCTAssertThrowsError("Can not find minimum geohash precision")
            return
        }
        
        // Then
        XCTAssertEqual(precision, .twentyFourHundredMeters)
    }
    
    func test_주어진반경1KM의필요한최소한의정확도가올바른지() throws {
        // Given
        let radiusInMeter: Double = 1000
        
        // When
        guard let precision = GeohashPrecision.minimumGeohashPrecisionLength(when: radiusInMeter) else {
            XCTAssertThrowsError("Can not find minimum geohash precision")
            return
        }
        
        // Then
        XCTAssertEqual(precision, .sixHundredTenMeters)
    }

}
