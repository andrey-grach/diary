import UIKit

//@IBDesignable
final class EventView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        titleLabel.sizeToFit()

    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

extension EventView {
    static func loadFromNib() -> EventView? {
        let nib = UINib(nibName: "EventView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? EventView
    }
}
