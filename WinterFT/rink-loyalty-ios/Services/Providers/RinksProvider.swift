//
//  RinksProvider.swift
//  rink-loyalty-ios
//
//  Created by Дамир Зарипов on 03/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import Moya

enum RinksProvider {

     // MARK: - Enumeration Cases

    case getRinks
}

// MARK: -

extension RinksProvider: DefaultTargetType {

    var path: String {
        switch self {
        case .getRinks:
            return "ice-rinks"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getRinks:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getRinks:
            return .requestPlain
        }
    }
}
