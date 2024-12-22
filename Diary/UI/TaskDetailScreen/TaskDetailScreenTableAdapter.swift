import Foundation
import UIKit

final class TaskDetailScreenTableAdapter: NSObject {
    var currentTask: TaskDetailTableViewCellData?
}

extension TaskDetailScreenTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TaskDetailScreenTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailTableViewCell.identifier, for: indexPath)
        if let reusableCell = cell as? TaskDetailTableViewCell {
            guard let currentTask else { return UITableViewCell() }
            reusableCell.configureCellWith(
                data: .init(
                    title: currentTask.title,
                    date: currentTask.date,
                    description: currentTask.description
                )
            )
            reusableCell.contentView.setNeedsLayout()
            reusableCell.contentView.layoutIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
