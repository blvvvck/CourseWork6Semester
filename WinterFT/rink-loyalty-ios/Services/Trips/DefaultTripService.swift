//
//  DefaultTripService.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 13/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

struct DefaultTripService: TripService {

    // MARK: - Instance Properties

    let tripProvider: MoyaProvider<TripProvider>

    // MARK: - Instance Methods

    func saveTrip(with form: TripForm, onSuccess: @escaping (Trip) -> Void, onFailure: @escaping (String) -> Void) {
        self.tripProvider.request(.endTrip(form)) { result in
            switch result {
            case .success(let response):
                if let trip = try? response.map(Trip.self) {
                    onSuccess(trip)
                } else {
                    onFailure(Messages.badResponse)
                }

            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
    }

    func getTrips(onSuccess: @escaping ([Trip]) -> Void, onFailure: @escaping (String) -> Void) {
        self.tripProvider.request(.getTrips) { result in
            switch result {
            case .success(let response):
                if let trips = try? response.map([Trip].self) {
                    onSuccess(trips)
                } else {
                    onFailure(Messages.badResponse)
                }

            case .failure(let error):
                onFailure(error.localizedDescription)
        }
        }}
}
