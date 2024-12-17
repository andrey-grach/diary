import Foundation

final class CalendarManager {
    
    static var shared = CalendarManager()
    private let calendar = Calendar.current
    
    func getDaysInCurrentMonth() -> [(date: Date, day: Int)] {
        var days: [(Date, Int)] = []
        let today = Date()
        
        // Получаем первый и последний день текущего месяца
        let range = calendar.range(of: .day, in: .month, for: today)!
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append((date, day))
            }
        }
        return days
    }
    
    func getDateComponentsFor(calendarComponents: Set<Calendar.Component>, date: Date) -> DateComponents {
        calendar.dateComponents(calendarComponents, from: date)
    }
}
