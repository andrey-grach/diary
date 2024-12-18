import UIKit

final class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    @IBOutlet private weak var timeLabel: UILabel!
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCellWith(time: String ) {
        timeLabel.text = time
    }
}
