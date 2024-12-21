import Foundation
import UIKit

protocol TasksScreenCollectionAdapterOutput: AnyObject {
    func getSelectedCollectionViewCell() -> IndexPath?
    func updateDateLabelText(with: String)
    func updateSelectedDate(date: Date, indexPath: IndexPath)
}

final class TasksScreenCollectionAdapter: NSObject {
    struct Constants {
        static let numberOfIndentsInCollectionView: CGFloat = 6
        static let indentWidth: CGFloat = 6.0
    }
    
    weak var presenter: TasksScreenCollectionAdapterOutput?
    private var days: [(Date, Int)] = []
    private var calendarManager = CalendarManager.shared
    var collectionViewCellSize: CGSize = .zero
    
    override init() {
        self.days = calendarManager.getDaysInCurrentMonth()
    }
    
    private func getFormattedDateFor(date: Date, format: DateTimeFormat) -> String {
        DateHelper.getString(fromDate: date, format: format).capitalized
    }
}

extension TasksScreenCollectionAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyCollectionViewCell.identifier,
            for: indexPath
        )
        let dayTuple = days[indexPath.item]
        let date = dayTuple.0
        let day = dayTuple.1
        
        if let reusableCell = cell as? MyCollectionViewCell {
            let weekdayString = getFormattedDateFor(date: date, format: .EEE)
            reusableCell.configureWith(dayNumber: String(day), dayTitle: weekdayString)
            if indexPath == presenter?.getSelectedCollectionViewCell() {
                reusableCell.setSelected()
                presenter?.updateDateLabelText(with: getFormattedDateFor(date: date, format: .EEEEColondMMMMyyyy))
            }
        }
        return cell
    }
}

extension TasksScreenCollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.updateSelectedDate(date: days[indexPath.item].0, indexPath: indexPath)
    }
}

extension TasksScreenCollectionAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.indentWidth
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionViewCellSize
    }
}
