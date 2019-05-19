//
//  TripListViewController.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import UIKit
import CoreData

class TripListViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Nested Properties

        static let tripCellIdentifier = "TripListTableViewCell"
        static let navigationItemTitle = "История"

        static let tripCellHeight = 150
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showEndTrip = "ShowEndTrip"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    var trips: [Trip] = []

    // MARK: - Instance Methods

    @IBAction private func newTripButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: -

    private func fetchTrips() {
        let loadingViewController = LoadingViewController()

        self.present(loadingViewController, animated: true) {
            Services.tripService.getTrips(onSuccess: { [weak self] trips in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.trips = trips
                strongSelf.trips.sort(by: { $0.finishDate > $1.finishDate })

                strongSelf.tableView.reloadData()

                loadingViewController.dismiss(animated: true, completion: nil)
            }, onFailure: { [weak self] stringError in
                loadingViewController.dismiss(animated: true, completion: {
                    self?.present(DefaultAlertFactory().getAlert(with: stringError), animated: true, completion: nil)
                    Log.e(stringError)
                })
            })
        }
    }

    private func configureUI() {
        self.navigationItem.title = Constants.navigationItemTitle
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetchTrips()
        self.configureUI()
        self.tableView.register(UINib(nibName: Constants.tripCellIdentifier, bundle: nil),
                                forCellReuseIdentifier: Constants.tripCellIdentifier)
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
            guard let trip = sender as? Trip else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["trip": trip])
            }

        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension TripListViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tripCellIdentifier, for: indexPath) as! TripListTableViewCell
        let trips = self.trips[indexPath.row]
        cell.configureUI(with: trips)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TripListViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.tripCellHeight)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = self.trips[indexPath.row]

        self.performSegue(withIdentifier: Segues.showEndTrip, sender: trip)
    }
}
