import Foundation

protocol DateFormatting {
    func dateFromString(_ strDate: String?) -> Date
    func stringFromDate(date: Date) -> String
}

// DateFormatter configured for APOD dates
struct DefaultDateFormatter: DateFormatting {
	private let dateAndTimeFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
		return formatter
	}()
    
    func dateFromString(_ strDate: String?) -> Date {
        guard let strdate = strDate else {return Date() }
        return dateAndTimeFormatter.date(from: strdate) ?? Date()
    }
    
    func stringFromDate(date: Date) -> String {
        return dateAndTimeFormatter.string(from: date)
    }
}
