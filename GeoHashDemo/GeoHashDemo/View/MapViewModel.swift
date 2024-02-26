//
//  MapViewModel.swift
//  GeoHashDemo
//
//  Created by Martin on 2/23/24.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    
    @Published var mapCameraPosition: MapCameraPosition = .automatic
    @Published var currentCenterCoordinate: CLLocationCoordinate2D?
    @Published var locations: [GeoLocation] = []
    
    var locationManager: CLLocationManager?
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    @MainActor
    func fetchGeoLocation(in radiusM: Double) async {
        guard let currentCenterCoordinate else { return }
        guard let searchingGeohashes = container.service.geohashService.overlappedGeohashes(
            from: currentCenterCoordinate,
            in: radiusM
        ) else { return }
        
        do {
            self.locations = try await container.service.geoLocationService.fetchAround(
                from: currentCenterCoordinate,
                in: radiusM,
                searchingIn: searchingGeohashes
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startUpdateUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.delegate = self
    }
    
    func setCurrentCenterCoordinate(_ coordinate: CLLocationCoordinate2D) {
        self.currentCenterCoordinate = coordinate
    }
    
    private func checkLocationAuthorization() {
        guard let location = locationManager else {
            return
        }
        
        switch location.authorizationStatus {
        case .notDetermined:
            print("Location authorization is not determined.")
        case .restricted:
            print("Location is restricted.")
        case .denied:
            print("Location permission denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = location.location {
                
                mapCameraPosition = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ))
                setCurrentCenterCoordinate(location.coordinate)
            }
            
        default:
            break
        }
    }
    
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestWhenInUseAuthorization()
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        mapCameraPosition = .region(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
}
