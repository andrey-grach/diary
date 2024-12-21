import UIKit

struct TaskDetailTableViewCellData {
    let title: String
    let date: String
    let description: String
}

final class TaskDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let identifier = "TaskDetailTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCellWith(data: TaskDetailTableViewCellData) {
        taskLabel.text = data.title
        dateLabel.text = data.date
        descriptionLabel.text = data.description
    }
}
