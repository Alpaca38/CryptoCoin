//
//  DateFormatManger.swift
//  CryptoCoin
//
//  Created by 조규연 on 9/7/24.
//

import Foundation

final class DateFormatManager {
    private init() { }
    static let shared = DateFormatManager()
    
    private let isoDateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    func toDateTime(updatedAt: String) -> String {
        guard let date = isoDateFormatter.date(from: updatedAt) else { return "toDateTimeError" }
        return date.formatted(.dateTime.month(.defaultDigits).day(.defaultDigits).hour(.conversationalDefaultDigits(amPM: .abbreviated)).minute().second().locale(Locale(identifier: "ko_KR")))
    }
}
