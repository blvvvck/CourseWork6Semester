//
//  StartViewController.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit
import CoreLocation

class StartViewController: LoggedViewController, CLLocationManagerDelegate {

    // MARK: - Instance Properties

    private var locationManager: CLLocationManager?

    // MARK: - Instance Methods

    private func configureLocationManager() {
        self.locationManager = LocationManager.shared.locationManager
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.locationManager?.delegate = nil
    }
}
