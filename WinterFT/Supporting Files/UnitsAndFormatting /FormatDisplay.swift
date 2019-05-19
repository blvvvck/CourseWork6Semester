//
//  FormatDisplay.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 19/12/2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import Foundation

enum FormatDisplay {
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return FormatDisplay.distance(distanceMeasurement)
    }
    
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(from: distance)
    }
    
    static func calorie(_ calorie: Double) -> String {
        let distanceMeasurement = Measurement(value: calorie, unit: UnitEnergy.joules)
        return FormatDisplay.calorie(distanceMeasurement)
    }
    
    static func calorie(_ calorie: Measurement<UnitEnergy>) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(from: calorie)
    }
    
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static func timeWithBriefUnitStyle(_ seconds: Int) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static func date(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru")
        return formatter.string(from: timestamp)
    }

    static func date(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru")
        return formatter.string(from: date)
    }

    static func tripDuration(_ start: TimeInterval, finish: TimeInterval) -> String {
        let startDate = Date(timeIntervalSince1970: start)
        let finishDate = Date(timeIntervalSince1970: finish)

        let dateFormatter = DateFormatter()

        let userCalendar = Calendar.current
        
        let requestedComponent: Set<Calendar.Component> = [.hour,.minute,.second]

        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"

        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startDate, to: finishDate)

        guard let minutes = timeDifference.minute, let seconds = timeDifference.second else {
            return "0"
        }

        return "\(minutes) Минут \(seconds) Секунд"
    }
}
