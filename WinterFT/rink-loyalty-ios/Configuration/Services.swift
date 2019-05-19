//
//  Services.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

enum Services {

    // MARK: - Type Properties

    private static let authorizationProvider = MoyaProvider<AuthorizationProvider>()

    private static let rinksProvider = MoyaProvider<RinksProvider>()

    private static let tripProvider = MoyaProvider<TripProvider>()

    // MARK: -

    static let authorizationService: AuthorizationSerivce = DefaultAuthorizationService(authorizationProvider: Services.authorizationProvider)

    static let rinksService: RinksService = DefaultRinksService(rinksProvider: Services.rinksProvider)

    static let tripService: TripService = DefaultTripService(tripProvider: Services.tripProvider)
}
