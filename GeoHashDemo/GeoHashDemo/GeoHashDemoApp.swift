//
//  GeoHashDemoApp.swift
//  GeoHashDemo
//
//  Created by Martin on 2/22/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct GeoHashDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var container: DIContainer = .init(service: Service())
    
    var body: some Scene {
        WindowGroup {
            MapView(viewModel: .init(container: container))
                .environmentObject(container)
        }
    }
}
