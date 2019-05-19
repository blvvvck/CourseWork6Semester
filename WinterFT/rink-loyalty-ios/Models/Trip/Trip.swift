//
//  Trip.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 04/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

struct Trip: Codable {

    // MARK: - Instance Properties

    let iceRink: Rink
    let calories: Int
    let distance: Double
    let startDate: TimeInterval
    let finishDate: TimeInterval
    let gift: Bool?
    let distances: [Double]
    let durations: [Double]
}
