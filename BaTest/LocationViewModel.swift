//
//  LocationViewModel.swift
//  BaTest
//
//  Created by Safa Şık on 20.11.23.
//

import Foundation
import CoreMotion
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    private var locationManager: CLLocationManager?
    @Published var speed: Double = 0.0
    @Published var averageSpeed: Double = 0.0
    @Published var log: String = ""
    @Published var maxSpeed: Double = 0.0
    @Published var totalDistance: Double = 0.0
    
    private var lastLocation: CLLocation?
    private var startTime: Date?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            log = "Location authorization always granted"
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            startTime = Date()
            log = "Location authorization when in use granted"
        @unknown default:
            log = "Unknown authorization status"
        }
    }
    
    func resetDistanceAndTopSpeed() {
        self.maxSpeed = 0
        self.totalDistance = 0
        self.averageSpeed = 0
        self.startTime = Date()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: currentLocation)
            totalDistance += distance / 1000.0 // convert to kilometers

            speed = currentLocation.speed
            if speed < 0 {
                speed = 0
            }

            if speed > maxSpeed {
                maxSpeed = speed
            }

            if let startTime = startTime {
                let elapsedTime = Date().timeIntervalSince(startTime)
                let totalDistanceRounded = totalDistance.rounded(toPlaces: 1) * 1000
                let elapsedTimeRounded = elapsedTime.rounded(toPlaces: 1)

                averageSpeed = totalDistanceRounded / elapsedTimeRounded // convert to km/h
            }
        }

        lastLocation = currentLocation
    }
}
