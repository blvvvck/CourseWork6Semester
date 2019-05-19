//
//  DateExtension.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 20/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

extension Date {
    func dataFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
