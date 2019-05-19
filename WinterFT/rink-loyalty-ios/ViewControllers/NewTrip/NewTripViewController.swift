//
//  NewTripViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

class NewTripViewController: LoggedViewController, MessagePresenting {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Nested Properties

        static let welcomeViewControllerIdentifier = "WelcomeViewController"
        static let tripListViewControllerIdentifier = "TripListViewController"
        static let locationRequestViewControllerIdentifier = "LocationRequestViewController"
        static let navigationItemTitle = "Зимняя сказка"
        static let russianEnergyCaption = "ккал"

        static let secondsInAMinute = 60
        static let calorieFactor = 0.038

        static let distanceFromCurrentLocation: Double = 20
        static let locationUpdateTime: Double = 10
    }

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showEndTrip = "ShowEndTrip"
        static let showLocationRequest = "ShowLocationRequest"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var tripListButton: UIButton!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var congratulationsTextLabel: UILabel!
    @IBOutlet private weak var distanceTextLabel: UILabel!
    @IBOutlet private weak var caloriesTextLabel: UILabel!

    // MARK: -

    private var trip: Trip?
    private var rink: Rink?
    private var timer = Timer()
    private var locationTimer: Timer?
    private var locationList: [CLLocation] = []
    private var notificationTime = 3_600
    private var seconds: Double = 0
    private var distanceArray: [Double] = []
    private var durationArray: [Double] = []
    private let userDefaults = UserDefaults.standard
    private var distance = Measurement(value: 0, unit: UnitLength.meters)

    // MARK: -

    private var calorie: Int {
        return Int(self.distance.value * Constants.calorieFactor)
    }

    private var isUserInsideRink: Bool {
        guard let rink = self.rink else {
            return false
        }

        guard let currentLocation = LocationManager.shared.locationManager.location?.coordinate else {
            return false
        }

        let points = [
            CLLocationCoordinate2D(latitude: rink.area.leftBottom.latitude, longitude: rink.area.leftBottom.longitude),
            CLLocationCoordinate2D(latitude: rink.area.leftTop.latitude, longitude: rink.area.leftTop.longitude),
            CLLocationCoordinate2D(latitude: rink.area.rightTop.latitude, longitude: rink.area.rightTop.longitude),
            CLLocationCoordinate2D(latitude: rink.area.rightBottom.latitude, longitude: rink.area.rightBottom.longitude)
        ]

        return currentLocation.contained(by: points)
    }

    // MARK: -

    private(set) var shouldApplyData = true

    // MARK: - Instance Methods

    @IBAction private func tripListButtonTouchUpInside(_ sender: UIButton) {
        guard let tripListViewController = storyboard?.instantiateViewController(withIdentifier: Constants.tripListViewControllerIdentifier) as? TripListViewController else {
            return
        }

        self.navigationController?.pushViewController(tripListViewController, animated: true)
    }

    @IBAction private func startButtonTouchUpInside(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.performSegue(withIdentifier: Segues.showLocationRequest, sender: nil)

                return

            case .authorizedAlways, .authorizedWhenInUse:
                if self.isUserInsideRink {
                    self.startTrip()

                    UserNotificationsManager.shared.userRequest()

                    self.setupLocalNotification()
                } else {
                    self.showMessage(withTitle: "Кажется, вы не на катке", message: "Для начала поездки необходимо находится на территории катка")
                }
            }
        }
    }

    @IBAction private func stopButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.stopTrip()
    }

    @IBAction private func onDistanceLabelTap(_ sender: UITapGestureRecognizer) {
        // swiftlint:disable shorthand_operator
        self.distance = self.distance + Measurement(value: 5_000, unit: UnitLength.meters)

        self.updateDisplay()
    }

    private func setupLocalNotification() {
        UserNotificationsManager.shared.scheduleNotification(inSeconds: TimeInterval(self.notificationTime))
    }

    private func configureUI() {
        self.navigationItem.title = Constants.navigationItemTitle
    }

    private func checkedIsOnboardinFinished() {
        if isOnboardingFinished() == false {
            guard let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.welcomeViewControllerIdentifier) as? WelcomeViewController else {
                return
            }

            self.present(welcomeViewController, animated: false, completion: nil)
        }
    }

    private func setupLocationSettings() {
        LocationManager.shared.delegate = self
    }

    private func isOnboardingFinished() -> Bool {
        return UserDefaultsManager.shared.getOnboardingState()
    }

    private func startTrip() {
        self.timeLabel.textColor = Colors.rinkLoyaltyTextColor
        self.distanceLabel.textColor = Colors.rinkLoyaltyTextColor
        self.caloriesLabel.textColor = Colors.rinkLoyaltyTextColor
        self.startButton.isHidden = true
        self.tripListButton.isHidden = true
        self.informationLabel.isHidden = false
        self.congratulationsTextLabel.textColor = UIColor.black
        self.distanceTextLabel.textColor = UIColor.black
        self.caloriesTextLabel.textColor = UIColor.black

        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        self.startLocationUpdates()
    }

    public func stopTrip() {
        UserNotificationsManager.shared.removeAllPendingNotificationRequests()

        let loadingViewController = LoadingViewController()

        self.present(loadingViewController, animated: true, completion: { [unowned self] in
            self.saveTrip(loadingViewController: loadingViewController)
        })
    }

    private func eachSecond() {
        self.seconds += 1
        self.updateDisplay()
    }

    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(self.distance)
        let formattedTime = FormatDisplay.time(Int(self.seconds))
        let calorie = self.calorie

        self.distanceLabel.text = "\(formattedDistance)"
        self.timeLabel.text = "\(formattedTime)"
        self.caloriesLabel.text = "\(calorie) \(Constants.russianEnergyCaption)"
    }

    private func startLocationUpdates() {
        self.seconds = 0
        self.distance = Measurement(value: 0, unit: UnitLength.meters)
        self.locationList.removeAll()
        self.updateDisplay()
    }

    private func saveTrip(loadingViewController: LoadingViewController) {
        guard let rink = self.rink else {
            return
        }

        let currentTimeInterval = Date().timeIntervalSince1970

        let createTripForm = TripForm(rinkID: rink.id,
                                      startDate: currentTimeInterval - self.seconds,
                                      finishDate: currentTimeInterval,
                                      distance: self.distance.value,
                                      calories: self.calorie,
                                      distances: self.distanceArray,
                                      durations: self.durationArray)

        Services.tripService.saveTrip(with: createTripForm, onSuccess: { [weak self] trip in
            loadingViewController.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: Segues.showEndTrip, sender: (trip: trip, rink: trip.iceRink))
                }
            })
        }, onFailure: { [weak self] stringError in
            loadingViewController.dismiss(animated: true, completion: {
                Log.e(stringError)
                self?.present(DefaultAlertFactory().getAlert(with: stringError), animated: true, completion: nil)
            })
        })
    }

    private func resetTimerTrip() {
        self.seconds = 0
        self.distance = Measurement(value: 0, unit: UnitLength.meters)
        self.updateDisplay()
        self.startButton.isHidden = false
        self.informationLabel.isHidden = true
        self.timeLabel.textColor = Colors.lightGrayTextColor
        self.distanceLabel.textColor = Colors.lightGrayTextColor
        self.caloriesLabel.textColor = Colors.lightGrayTextColor
    }

    private func setupLocationManager() {
        LocationManager.shared.setupLocationManager()
        LocationManager.shared.startUpdatingLocation()
    }

    // MARK: -

    private func apply(rink: Rink) {
        Log.i(rink.name)

        self.rink = rink

        if self.isViewLoaded {
            self.navigationItem.title = rink.name

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLocationSettings()
        self.configureUI()
        self.setupLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let rink = self.rink {
            self.apply(rink: rink)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.timer.invalidate()
        self.locationTimer?.invalidate()
        self.resetTimerTrip()
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
        case Segues.showEndTrip:
            guard let data = sender as? (trip: Trip, rink: Rink) else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["trip": data.trip, "rink": data.rink])
            }

        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension NewTripViewController: LocationControllerDelegate {

    // MARK: - Instance Methods

    func didUpdateLocations(with locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow

            guard newLocation.horizontalAccuracy < Constants.distanceFromCurrentLocation && abs(howRecent) < Constants.locationUpdateTime else {
                continue
            }

            guard self.isUserInsideRink else {
                continue
            }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)

                self.distance = self.distance + Measurement(value: delta, unit: UnitLength.meters)
            }

            self.distanceArray.append(self.distance.value)
            self.durationArray.append(self.seconds / Double(Constants.secondsInAMinute))
            self.locationList.append(newLocation)
        }
    }

    func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .notDetermined, .restricted:
            self.performSegue(withIdentifier: Segues.showLocationRequest, sender: nil)

        default:
            break
        }
    }
}

// MARK: - DictionaryReceiver

extension NewTripViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let rink = dictionary["rink"] as? Rink else {
            return
        }

        self.apply(rink: rink)
    }
}
