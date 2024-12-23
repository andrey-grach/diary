import Foundation
import UIKit

final class TextInputField: UIView {
    
    // MARK: - Private properties
    
    private let textField = UITextField()
    private let placeholderLabel = UILabel()
}

// MARK: - UITextInputDelegate

extension TextInputField: UITextInputDelegate {
    func selectionWillChange(_ textInput: (any UITextInput)?) {}
    
    func selectionDidChange(_ textInput: (any UITextInput)?) {}
    
    func textWillChange(_ textInput: (any UITextInput)?) {}
    
    func textDidChange(_ textInput: (any UITextInput)?) {}
}
