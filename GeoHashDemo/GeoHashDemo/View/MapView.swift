//
//  MapView.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    static var seoulCityHall: Self {
        MKCoordinateRegion(
            center: .init(latitude: 37.566300, longitude: 126.977946),
            span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @State private var shouldPresentAddLocationSheet: Bool = false
    @Namespace var mapScope
    
    init(viewModel: MapViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
 
    var body: some View {
        
        Map(position: $viewModel.mapCameraPosition, scope: mapScope) {
            UserAnnotation()
            ForEach(viewModel.locations, id: \.self) { location in
                Marker(location.title, coordinate: location.location.coordinate)
            }
        }
        .mapControls{
            MapCompass()
            MapUserLocationButton()
            MapPitchToggle()
            MapScaleView()
        }
        .overlay(alignment: .bottom) {
            Button {
                shouldPresentAddLocationSheet = true
            } label: {
                Image(systemName: "plus.rectangle.fill")
                    .font(.largeTitle)
                    .padding(.bottom)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                Button("100M") {
                    Task {
                        await viewModel.fetchGeoLocation(in: 100)
                    }
                }
                Button("500M") { 
                    Task {
                        await viewModel.fetchGeoLocation(in: 500)
                    }
                }
                Button("1KM") {
                    Task {
                        await viewModel.fetchGeoLocation(in: 1000)
                    }
                }
                Button("5KM") { 
                    Task {
                        await viewModel.fetchGeoLocation(in: 5000)
                    }
                }
                Button("10KM") {
                    Task {
                        await viewModel.fetchGeoLocation(in: 10000)
                    }
                }
            }
            .padding()
        }
        .onMapCameraChange {
            viewModel.setCurrentCenterCoordinate($0.camera.centerCoordinate)
        }
        .sheet(isPresented: $shouldPresentAddLocationSheet) {
            AddNewLocationView(currentCenterCoordinate: viewModel.currentCenterCoordinate)
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.startUpdateUserLocation()
        }
        .tint(.red)
        
        
    }
}




#Preview {
    MapView(viewModel: .init(container: .init(service: StubService())))
}
