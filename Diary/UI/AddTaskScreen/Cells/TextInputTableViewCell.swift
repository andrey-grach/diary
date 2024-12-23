import Foundation
import UIKit
import SnapKit

enum InputType {
    case title
    case description
    case none
}

protocol TextInputTableViewCellDelegate: AnyObject {
    func textFieldDidChange(in cell: TextInputTableViewCell)
    func textFieldDidReturn(in cell: TextInputTableViewCell)
}

final class TextInputTableViewCell: UITableViewCell {
    static let identifier = "TextInputTableViewCell"
    var text: String = .empty
    private(set) var textInputField = UITextField()
    weak var delegate: TextInputTableViewCellDelegate?
    
    var inputType: InputType = .none {
        didSet {
            setupTextField()
        }
    }
    
    func configureCell(inputType: InputType) {
        contentView.addSubviews(textInputField)
        textInputField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textInputField.delegate = self
        self.inputType = inputType
    }
    
    private func setupTextField() {
        guard inputType != .none else { return }
        switch inputType {
        case .title:
            textInputField.placeholder = "TextInputTableViewCell.InputType.Title".localized
        case .description:
            textInputField.placeholder = "TextInputTableViewCell.InputType.Description".localized
        case .none:
            textInputField.placeholder = .empty
        }
    }
}

extension TextInputTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInputField.resignFirstResponder()
        self.text = textField.text ?? .empty
        delegate?.textFieldDidChange(in: self)
        delegate?.textFieldDidReturn(in: self)
        return true
    }
}
