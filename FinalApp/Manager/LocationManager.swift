//  LocationManager.swift
//  FinalApp
//
//  Created by Sourav Choubey on 15/02/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    enum CustomError: Error {
        case locationAuthorizationDenied
    }

    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.completion = completion
    }
    
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("Location authorization denied or restricted")
            completion?(.failure(CustomError.locationAuthorizationDenied))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        completion?(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        completion?(.failure(error))
    }
}

