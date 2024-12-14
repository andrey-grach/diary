import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var weekDayLabel: UILabel!
    @IBOutlet weak private var dayNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with text: String) {
        
    }

}
