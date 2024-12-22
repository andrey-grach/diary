import UIKit

struct TaskDetailTableViewCellData {
    let title: String
    let date: String
    let description: String
}

final class TaskDetailTableViewCell: UITableViewCell {
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    static let identifier = "TaskDetailTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCellWith(data: TaskDetailTableViewCellData) {
        timeLabel.text = data.date
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
}
