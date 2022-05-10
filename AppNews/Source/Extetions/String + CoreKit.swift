//
//  String + CoreKit.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/8/22.
//

import Foundation

extension Date {

    func convertToDayMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d MMM yyyy"
        return formatted(.dateTime.day().month(.defaultDigits).year().hour().minute())
    }
}

extension String {

    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current

        return dateFormatter.date(from: self)
    }

    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToDayMonthYearFormat()
    }
}
