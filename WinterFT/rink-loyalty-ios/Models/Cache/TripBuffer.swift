//
//  TripBuffer.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 20/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

class TripBuffer {

    // MARK: - Type Properties

    static let shared = TripBuffer()

    // MARK: - Instance Properties

    var distance: String?
    var date: String?
    var time: String?
    var calorie: String?
    var textForSharing: String?

    // MARK: - Instance Methods

    func reset() {
        self.distance = nil
        self.date = nil
        self.time = nil
        self.calorie = nil
        self.textForSharing = nil
    }
}
