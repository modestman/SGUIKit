import InputMask
import RxRelay
import UIKit

/// Текст-филд с маской ввода
open class MaskedTextField: StyledTextField {
    
    // MARK: - Private properties
    
    private var isMasked: Bool = false
    
    // MARK: - Public properties

    public var inputMask: String? {
        didSet {
            if let mask = inputMask {
                isMasked = true
                maskDelegate.primaryMaskFormat = mask
                maskDelegate.autocompleteOnFocus = true
                maskDelegate.autocomplete = true
                maskDelegate.listener = self
                delegate = maskDelegate
            } else {
                isMasked = false
                delegate = self
            }
        }
    }

    public let cleanText = BehaviorRelay<String?>(value: nil)
    public var textFieldShouldReturnClosure: ((TextField) -> Bool)?
    public var textFieldDidEndEditingClosure: ((TextField) -> Void)?
    
    class var defaultMaskDelegate: MaskedTextFieldDelegate {
        MaskedTextFieldDelegate()
    }
    
    // swiftlint:disable:next weak_delegate
    public let maskDelegate: MaskedTextFieldDelegate

    override public var text: String? {
        didSet {
            if !isMasked {
                cleanText.accept(text)
            }
        }
    }

    // MARK: - Init

    override public init(frame: CGRect) {
        maskDelegate = type(of: self).defaultMaskDelegate
        super.init(frame: frame)
        delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        maskDelegate = type(of: self).defaultMaskDelegate
        super.init(coder: aDecoder)
        delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    // если не включена маска, здесь будет обновляться cleanText
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        if let currentText = textField.text {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            cleanText.accept(newText)
        }
        return true
    }
}

extension MaskedTextField: MaskedTextFieldDelegateListener {

    public func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        
        if autocapitalizationType == .allCharacters {
            textField.text = textField.text?.uppercased()
        }
        cleanText.accept(value)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldShouldReturnClosure?(self) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditingClosure?(self)
    }
    
}
