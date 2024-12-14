import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTitle.text = ""
        dateLabel.text = ""
    }
    
    public func configure(with text: String) {
        dateLabel.text = "Пн"
        cellTitle.text = text
    }

    static func nib() -> UINib {
        UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
}
