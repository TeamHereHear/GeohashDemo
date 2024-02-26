//
//  AddNewLocationView.swift
//  GeoHashDemo
//
//  Created by Martin on 2/24/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddNewLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var container: DIContainer
    
    let currentCenterCoordinate: CLLocationCoordinate2D?
    
    init(currentCenterCoordinate: CLLocationCoordinate2D?) {
        self.currentCenterCoordinate = currentCenterCoordinate
    }
    
    @State private var title: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if let coordinate = currentCenterCoordinate {
                    Map(
                        bounds: .init(
                            centerCoordinateBounds: .init(
                                center: coordinate,
                                span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            ),
                            minimumDistance: 500
                        ),
                        interactionModes: []
                    ) {
                        Marker("여기에 추가하기", coordinate: coordinate)
                        
                    }
                    .frame(maxHeight: 400)
                    
                    Form {
                        TextField("제목", text: $title)
                    }
                }
            }
            .toolbar {
                Button {
                    add()
                } label: {
                    Text("추가하기")
                }
            }
        }
        
    }
    
    private func add() {
        guard let currentCenterCoordinate else { return }
        guard !title.isEmpty else { return }
        do {
            let geohash = container.service.geohashService.geohash(for: currentCenterCoordinate)
            
            _ = try container.service.geoLocationService.add(
                .init(
                    id: UUID().uuidString,
                    title: title,
                    location: .init(
                        geoHash: geohash,
                        lat: currentCenterCoordinate.latitude,
                        long: currentCenterCoordinate.longitude
                    )
                )
            )
            
            title = ""
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}
