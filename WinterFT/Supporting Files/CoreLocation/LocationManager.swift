//
//  LocationManager.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 19/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationControllerDelegate: class {

    // MARK: - Instance Methods
    
    func didUpdateLocations(with locations: [CLLocation])
    func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus)
}

class LocationManager: NSObject {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let minimumDistanceBeforeAnUpdate: Double = 10
    }

    // MARK: - Type Properties
    
    static let shared = LocationManager()

    // MARK: - Instance Properties
    
    weak var delegate: LocationControllerDelegate?
        
    var locationManager: CLLocationManager

    // MARK: - Initializers
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self
    }

    // MARK: - Instance Methods
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

    func setupLocationManager() {
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = Constants.minimumDistanceBeforeAnUpdate
        self.locationManager.allowsBackgroundLocationUpdates = true
    }

    func openSettings(){
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func requestWhenInUseAuthorization(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                self.openSettings()

            case .notDetermined, .restricted:
                self.locationManager.requestWhenInUseAuthorization()

            case .authorizedAlways, .authorizedWhenInUse:
                return
            }
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                self.locationManager.requestWhenInUseAuthorization()
                
            case .notDetermined, .restricted:
                self.locationManager.requestWhenInUseAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                return
            }
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    // MARK: - Instance Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.didUpdateLocations(with: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.didChangeAuthoriztionStatus(status)
    }
}
