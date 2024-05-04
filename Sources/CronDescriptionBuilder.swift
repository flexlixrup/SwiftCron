//
//  CronDescriptionBuilder.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/10.
//
//

import Foundation

enum CronDescriptionLength { case short, long }

class CronDescriptionBuilder {
    static let EveryWeekday: String = {
        let cronExp = CronExpression(cronString: "0 0 * * 1,2,3,4,5 *")!
        return DateFormatter.convertStringToDaysOfWeek(cronExp.cronRepresentation.weekday)
    }()

    static let EveryDay: String = {
        let cronExp = CronExpression(cronString: "0 0 * * 1,2,3,4,5,6,7 *")!
        return DateFormatter.convertStringToDaysOfWeek(cronExp.cronRepresentation.weekday)
    }()

    static func buildDescription(_ cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String {
        if let biggestField = cronRepresentation.biggestField {
            switch biggestField {
            case .minute:
                return descriptionWithMinuteBiggest(cronRepresentation, length: length)
            case .hour:
                return descriptionWithHourBiggest(cronRepresentation, length: length)
            case .day:
                return descriptionWithDayBiggest(cronRepresentation, length: length)
            case .month:
                return descriptionWithMonthBiggest(cronRepresentation, length: length)
            case .weekday:
                break
            case .year:
                return descriptionWithYearBiggest(cronRepresentation, length: length)
            }
        }
        return descriptionWithNoneBiggest(cronRepresentation, length: length)
    }

    private static func descriptionWithNoneBiggest(_ cronRepresentation: CronRepresentation, length _: CronDescriptionLength) -> String {
        if CronRepresentation.isDefault(cronRepresentation.weekday) {
			return String(localized: "Every minute", bundle: .module)
        } else {
            let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
            return String(localized: "Every minute on a \(weekday)", bundle: .module)
        }
    }

    private static func descriptionWithMinuteBiggest(_ cronRepresentation: CronRepresentation, length _: CronDescriptionLength) -> String {
        let minutes = DateFormatter.minuteStringWithMinute(cronRepresentation.minute)
        if CronRepresentation.isDefault(cronRepresentation.weekday) {
            return String(localized: "Every hour at \(minutes) minutes", bundle: .module)
        } else {
            let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
            return String(localized: "Every \(minutes) minutes on a \(weekday)", bundle: .module)
        }
    }

    private static func descriptionWithHourBiggest(_ cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String {
        let time = DateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)

        if CronRepresentation.isDefault(cronRepresentation.weekday) {
            switch length {
            case .long:
                return String(localized: "Every day at \(time)", bundle: .module)
            case .short:
                return String(localized: "Every day", bundle: .module)
            }
        } else {
            let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
            var desc: String
            if weekday == EveryDay {
                desc = String(localized: "Every day", bundle: .module)
            } else if weekday == EveryWeekday {
                desc = String(localized: "Every weekday", bundle: .module)
            } else {
                desc = String(localized: "Every \(weekday)", bundle: .module)
            }
            switch length {
            case .long:
                return String(localized: "\(desc) at \(time)", bundle: .module)
            case .short:
                return desc
            }
        }
    }

    private static func descriptionWithDayBiggest(_ cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String {
        let day = Int(cronRepresentation.day)!.ordinal

        if CronRepresentation.isDefault(cronRepresentation.hour) {
            let minutes = DateFormatter.minuteStringWithMinute(cronRepresentation.minute)
            return String(localized: "Every hour at \(minutes) minutes on the \(day)", bundle: .module)
        } else {
            let time = DateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
            if CronRepresentation.isDefault(cronRepresentation.weekday) {
                switch length {
                case .long:
                    return String(localized: "Every \(day) of the month at \(time)", bundle: .module)
                case .short:
                    return String(localized: "Every \(day) of the month", bundle: .module)
                }
            } else {
                let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
                switch length {
                case .long:
                    return String(localized: "Every \(weekday) the \(day) at \(time)", bundle: .module)
                case .short:
                    return String(localized: "Every \(weekday) the \(day)", bundle: .module)
                }
            }
        }
    }

    private static func descriptionWithMonthBiggest(_ cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String {
        let time = DateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
        let day = Int(cronRepresentation.day)!.ordinal
        let month = Int(cronRepresentation.month)!.convertToMonth()

        let desc = String(localized: "Every \(day) of \(month)", bundle: .module)
        if CronRepresentation.isDefault(cronRepresentation.weekday) {
            switch length {
            case .long:
                return String(localized: "\(desc) at \(time)", bundle: .module)
            case .short:
                return desc
            }
        } else {
            let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
            switch length {
            case .short:
                return String(localized: "Every \(weekday) the \(day) of \(month)", bundle: .module)
            case .long:
                return String(localized: "Every \(weekday) the \(day) of \(month) at \(time)", bundle: .module)
            }
        }
    }

    private static func descriptionWithYearBiggest(_ cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String {
        let time = DateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
        let day = Int(cronRepresentation.day)!.ordinal
        let month = Int(cronRepresentation.month)!.convertToMonth()

        let desc = String(localized: "\(day) of \(month) \(cronRepresentation.year)", bundle: .module)
        if CronRepresentation.isDefault(cronRepresentation.weekday) {
            switch length {
            case .short:
                return desc
            case .long:
                return String(localized: "\(desc) at \(time)", bundle: .module)
            }
        } else {
            let weekday = DateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
            switch length {
            case .short:
                return String(localized: "\(weekday) \(desc)", bundle: .module)
            case .long:
                return String(localized: "\(weekday) \(desc) at \(time)", bundle: .module)
            }
        }
    }
}
