//
//  TripProvider.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 04/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

enum TripProvider {

    // MARK: - Enumeration Cases

    case endTrip(TripForm)
    case getTrips
}

// MARK: -

extension TripProvider: DefaultTargetType {

    // MARK: - Instance Properties

    var path: String {
        switch self {
        case .endTrip, .getTrips:
            return "rides"
        }
    }

    var method: Moya.Method {
        switch self {
        case .endTrip:
            return .post

        case .getTrips:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .endTrip(let trip):
            var parameters: [String: Any] = [:]
            var rinkParameters: [String: Any] = [:]

            rinkParameters["id"] = trip.rinkID

            parameters["iceRink"] = rinkParameters
            parameters["startDate"] = trip.startDate
            parameters["finishDate"] = trip.finishDate
            parameters["distance"] = trip.distance
            parameters["calories"] = trip.calories
            parameters["distances"] = trip.distances
            parameters["durations"] = trip.durations

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

        case .getTrips:
            return .requestPlain
        }
    }
}
