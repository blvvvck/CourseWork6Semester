//
//  LocationRequestViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 21/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestViewController: LoggedViewController {

    // MARK: - Instance Properties

    @IBOutlet private weak var openSettingsButton: UIButton!

    private var locationManager = CLLocationManager()

    // MARK: - Instance Methods

    @IBAction private func openSettingsButtonTouchUpInside(_ sender: UIButton) {
        LocationManager.shared.requestWhenInUseAuthorization()
    }

    // MARK: -

    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { success in
                Log.i(success)
            })
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationRequestViewController: CLLocationManagerDelegate {

    // MARK: - Instance Methods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:

            self.dismiss(animated: true, completion: nil)

        default:
            break
        }
    }
}
