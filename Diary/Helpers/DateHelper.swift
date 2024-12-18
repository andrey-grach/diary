import Foundation

enum DateTimeFormat {
    case hhmmColon
    case EEEEColondMMMMyyyy
    case EEE
    
    func make() -> String {
        switch self {
        case .hhmmColon:
            return "HH:mm"
        case .EEEEColondMMMMyyyy:
            return "EEEE, d MMMM yyyy"
        case .EEE:
            return "EEE"
        }
    }
}

private func dateFormatter(timeZone: TimeZone) -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = Locale(identifier: "ru")
    return dateFormatter
}

final class DateHelper {
    static func getDate(
        fromString string: String,
        format: DateTimeFormat,
        timeZone: TimeZone = .current
    ) -> Date? {
        let dateFormatter = dateFormatter(timeZone: timeZone)
        dateFormatter.dateFormat = format.make()
        return dateFormatter.date(from: string)
    }
    
    static func getString(
        fromDate date: Date?,
        format: DateTimeFormat,
        timeZone: TimeZone = .current
    ) -> String {
        guard let date = date else { return .empty }
        let dateFormatter = dateFormatter(timeZone: timeZone)
        dateFormatter.dateFormat = format.make()
        return dateFormatter.string(from: date)
    }
    
    static func getDate(fromTimestamp timestamp: String) -> Date? {
        guard let timeInterval = TimeInterval(timestamp) else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
