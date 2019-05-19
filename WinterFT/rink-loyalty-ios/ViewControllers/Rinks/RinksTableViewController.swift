//
//  RinksTableViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

class RinksTableViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let rinkCellIdentifier = "RinkCell"
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showNewTrip = "ShowNewTrip"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    private var rinks: [Rink] = []
    private var sortedRinks: [(key: Rink, value: Double)] = []

    private var locationManager = CLLocationManager()

    // MARK: -

    var isLocationAllowed: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true

        case .denied, .notDetermined, .restricted:
            return false
        }
    }

    // MARK: - Instance Methods

    private func configTableView() {
        self.tableView.tableFooterView = UIView()
    }

    private func config(cell: RinkTableViewCell, rink: Rink, distance: Double? = nil) {
        cell.name = rink.name
        cell.address = rink.address
        cell.entrancePrice = "\(rink.entrancePrice)"
        cell.skateRentalPrice = "\(rink.skateRentalPrice)"

        if let rawIndex = rink.workSchedule.firstIndex(of: ";") {
            var schedule = rink.workSchedule
            let index = rink.workSchedule.index(after: rawIndex)

            schedule.insert("\n", at: index)

            cell.workSchedule = schedule
        } else {
            cell.workSchedule = rink.workSchedule
        }

        if let distance = distance {
            cell.distance = "\(Int(distance)) метров"
        } else {
            cell.distance = "Нет данных"
        }
    }

    private func refreshRinks() {
        let loadingViewController = LoadingViewController()

        self.present(loadingViewController, animated: true, completion: {
            Services.rinksService.getRinks(onSuccess: { [weak self] rinks in
                guard let `self` = self else {
                    return
                }

                self.rinks = rinks
                self.geolocationSorting()

                self.tableView.reloadData()

                loadingViewController.dismiss(animated: true, completion: nil)
            }, onFailure: { [weak self] error in
                loadingViewController.dismiss(animated: true, completion: {
                    self?.present(DefaultAlertFactory().getAlert(with: error), animated: true, completion: nil)
                })
            })
        })
    }

    private func geolocationSorting() {
        var rinkDestinations: [Rink: Double] = [:]

        guard let currentLocation = LocationManager.shared.locationManager.location else {
            return
        }

        self.rinks.forEach {
            let rinkLocation = CLLocation(latitude: $0.area.center.latitude, longitude: $0.area.center.longitude)

            rinkDestinations[$0] = currentLocation.distance(from: rinkLocation)
        }

        self.sortedRinks = Array(rinkDestinations).sorted { $0.1 < $1.1 }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        LocationManager.shared.checkAuthorizationStatus()
        self.configTableView()

        self.refreshRinks()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showNewTrip:
            guard let rink = sender as? Rink else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["rink": rink])
            }

        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension RinksTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.v("isLocationAllowed: \(self.isLocationAllowed)")
        Log.v("sortedRinks count: \(self.sortedRinks.count)")
        Log.v("rinks count: \(self.rinks.count)")

        return self.isLocationAllowed ? self.sortedRinks.count : self.rinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rinkCellIdentifier, for: indexPath)

        if self.isLocationAllowed {
            self.config(cell: cell as! RinkTableViewCell, rink: self.sortedRinks[indexPath.row].key, distance: self.sortedRinks[indexPath.row].value)
        } else {
            self.config(cell: cell as! RinkTableViewCell, rink: self.rinks[indexPath.row])
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension RinksTableViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let rink = self.isLocationAllowed ? self.sortedRinks[indexPath.row].key : self.rinks[indexPath.row]

        self.performSegue(withIdentifier: Segues.showNewTrip, sender: rink)
    }
}

// MARK: - CLLocationManagerDelegate

extension RinksTableViewController: CLLocationManagerDelegate {

    // MARK: - Instance Methods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.refreshRinks()
    }
}
