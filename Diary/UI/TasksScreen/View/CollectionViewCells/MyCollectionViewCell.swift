import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekDayLabel.text = ""
        dateLabel.text = ""
        deselectCell()
    }
    
    static func nib() -> UINib {
        UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    func configureWith(dayNumber: String, dayTitle: String) {
        weekDayLabel.text = dayTitle
        dateLabel.text = dayNumber
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            selectCell()
        } else {
            deselectCell()
        }
    }
    
    private func selectCell() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = bounds.width / 4
    }
    
    private func deselectCell() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0.0
        layer.cornerRadius = 0.0
    }
}
