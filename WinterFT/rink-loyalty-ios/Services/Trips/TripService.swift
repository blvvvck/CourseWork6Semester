//
//  TripService.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 13/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

protocol TripService {

    // MARK: - Instance Methods

    func saveTrip(with form: TripForm, onSuccess: @escaping (Trip) -> Void, onFailure: @escaping (String) -> Void)
    func getTrips(onSuccess: @escaping ([Trip]) -> Void, onFailure: @escaping (String) -> Void)
}
