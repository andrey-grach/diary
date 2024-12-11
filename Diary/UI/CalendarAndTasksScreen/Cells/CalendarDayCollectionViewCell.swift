import UIKit

final class CalendarDayCollectionViewCell: UICollectionViewCell {

    static let identifier = "CalendarDayCollectionViewCell"
    @IBOutlet var calendarDay: UILabel!
    
    public func configure(with text: String) {
        calendarDay.text = text
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
