//
//  DefaultTargetType.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 14/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

protocol DefaultTargetType: TargetType { }

// MARK: -

extension DefaultTargetType {

    // MARK: - Instance Properties

    var baseURL: URL {
        return URL(string: "https://winter-fairytale.herokuapp.com/")!
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        guard let token = UserDefaultsManager.shared.getToken() else {
            return nil
        }

        return ["Authorization": token]
    }
}
