import UIKit

struct EventViewData {
    let title: String
    let date: String
}

final class EventView: UIView {
    static let indentifier: String = "EventView"
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBInspectable private var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }
    
    func configure(with data: EventViewData) {
        timeLabel.text = data.date
        titleLabel.text = data.title
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.91)
        ])
    }
}

extension EventView {
    static func loadFromNib() -> EventView? {
        let nib = UINib(nibName: EventView.indentifier, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? EventView
    }
}
