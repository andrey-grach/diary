import UIKit

final class TaskTableViewCell: UITableViewCell {
    @IBOutlet private weak var timeLabel: UILabel!
    
    static let identifier = "TaskTableViewCell"
    
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
