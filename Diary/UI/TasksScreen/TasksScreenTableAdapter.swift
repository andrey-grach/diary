import Foundation
import UIKit

protocol TasksScreenTableAdapterOutput: AnyObject {
    func prepareTasksForSelectedDate(tasks: [TasksItem]) -> [TasksItem?]
    func addEventView(taskItem: TasksItem?)
}

final class TasksScreenTableAdapter: NSObject {
    weak var presenter: TasksScreenTableAdapterOutput?

    struct Constants {
        static let hoursInDay = 24
    }
    var tasks: [TasksItem] = []
}

extension TasksScreenTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.hoursInDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hour = indexPath.row // Час, соответствующий текущему индексу
        let timeInterval = String(format: "%02d:00", hour)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
        
        if let reusableCell = cell as? TaskTableViewCell {
            guard let hourlyTasks = presenter?.prepareTasksForSelectedDate(tasks: tasks) else { return UITableViewCell() }
            if let task = hourlyTasks[hour] {
                reusableCell.configureCellWith(time: timeInterval)
                presenter?.addEventView(taskItem: tasks.first(where: { $0.id == task.id }))
            } else {
                reusableCell.configureCellWith(time: timeInterval)
            }
        }
        return cell
    }
}

extension TasksScreenTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
