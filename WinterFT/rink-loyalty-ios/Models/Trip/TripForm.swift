//
//  TripForm.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 18/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

struct TripForm {

    // MARK: - Instance Properties

    let rinkID: Int
    let startDate: TimeInterval
    let finishDate: TimeInterval
    let distance: Double
    let calories: Int
    let distances: [Double]
    let durations: [Double]
}
