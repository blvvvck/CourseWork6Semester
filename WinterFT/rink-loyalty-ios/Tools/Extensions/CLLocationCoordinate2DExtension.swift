//
//  CLLocationCoordinate2DExtension.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 14/05/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import CoreLocation
import CoreGraphics

extension CLLocationCoordinate2D {

    // MARK: - Instance Methods

    func contained(by vertices: [CLLocationCoordinate2D]) -> Bool {
        let path = CGMutablePath()

        vertices.forEach {
            if path.isEmpty {
                path.move(to: CGPoint(x: $0.longitude, y: $0.latitude))
            } else {
                path.addLine(to: CGPoint(x: $0.longitude, y: $0.latitude))
            }
        }

        let point = CGPoint(x: self.longitude, y: self.latitude)

        return path.contains(point)
    }
}
