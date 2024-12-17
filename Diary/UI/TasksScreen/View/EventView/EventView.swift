import UIKit

//final class EventView: UIView {
//
//    @IBOutlet private weak var titleLabel: UILabel!
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//
//    override func layoutSubviews() {
////        titleLabel.sizeToFit()
//    }
//
//    func configure(with title: String) {
//        let screenWidth = UIScreen.main.bounds.width
//        titleLabel.text = title
//        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
//    }
//}
//
//extension EventView {
//    static func loadFromNib() -> EventView? {
//        let nib = UINib(nibName: "EventView", bundle: nil)
//        return nib.instantiate(withOwner: nil, options: nil).first as? EventView
//    }
//}

final class EventView: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.91)
            //            titleLabel.heightAnchor.constraint(equalToConstant: 50), // Пример высоты
            //            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor), // Центрирование по вертикали
            //            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor) // Центрирование по горизонтали
        ])
    }
    
    func configure(timeStart: String, timeFinish: String, title: String) {
        let dateStart = Date(timeIntervalSince1970: Double(timeStart)!)
        let dateFinish = Date(timeIntervalSince1970: Double(timeFinish)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Установка формата времени
        let timeStartString = dateFormatter.string(from: dateStart)
        let timeFinishString = dateFormatter.string(from: dateFinish)
        timeLabel.text = timeStartString + " - " + timeFinishString
        titleLabel.text = title
        self.layoutIfNeeded()
    }
}

extension EventView {
    static func loadFromNib() -> EventView? {
        let nib = UINib(nibName: "EventView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as? EventView
    }
}
