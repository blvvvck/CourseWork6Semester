//
//  Rink.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 13/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

struct Rink: Codable, Hashable {

    // MARK: - Instance Properties

    let id: Int
    let name: String
    let address: String
    let entrancePrice: Int
    let skateRentalPrice: Int
    let workSchedule: String
    let area: Area
}
