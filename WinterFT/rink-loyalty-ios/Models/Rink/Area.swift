//
//  Area.swift
//  rink-loyalty-ios
//
//  Created by Дамир Зарипов on 03/04/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import GLKit
import CoreLocation

struct Area: Codable, Hashable {

    // MARK: - Instance Properties

    let rightTop: Coordinate
    let rightBottom: Coordinate
    let leftTop: Coordinate
    let leftBottom: Coordinate

    // MARK: -

    var center: Coordinate {
        let locationPoints = [self.leftBottom, self.leftTop, self.rightBottom, self.rightTop]

        var x: Float = 0.0
        var y: Float = 0.0
        var z: Float = 0.0

        for point in locationPoints {
            let lat = GLKMathDegreesToRadians(Float(point.latitude))
            let long = GLKMathDegreesToRadians(Float(point.longitude))

            x += cos(lat) * cos(long)

            y += cos(lat) * sin(long)

            z += sin(lat)
        }

        x /= Float(locationPoints.count)
        y /= Float(locationPoints.count)
        z /= Float(locationPoints.count)

        let resultLong = atan2(y, x)
        let resultHyp = sqrt(x * x + y * y)
        let resultLat = atan2(z, resultHyp)
        let result = Coordinate(latitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLat))), longitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLong))))

        return result
    }
}
