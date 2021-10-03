import SGCommonHelpers
import UIKit

/// Текст-филд со вспылвающим заголовком
open class StyledTextField: TextField, Validatable {
    
    // MARK: - Types
    
    private enum Constants {
        static let rightPadding: CGFloat = 8.0
    }
    
    enum Appearance {
        case normal
        case error
        case disabled
    }

    // MARK: - Private properties
    
    private var appearance: Appearance = .normal {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Public properties
    
    public var validationClosure: TextValidationClosure?

    /// Проверяет введенное значение на валидность (не меняет стиль поля)
    public var isValid: Bool {
        (validationClosure?(text) ?? .valid).isValid
    }
    
    /// Текст отображемый под полем ввода, если нет ошибки
    open var helpText: String? {
        didSet {
            if isValid { detailText = helpText }
        }
    }
    
    // MARK: - Text Field override
    
    override open func commonInit() {
        super.commonInit()
        textBox.delegate = self
        setupStyle()
    }
    
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        validate()
        return super.resignFirstResponder()
    }
    
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                appearance = .normal
            } else {
                appearance = .disabled
            }
        }
    }
    
    /// Проверяет введенное значение на валидность и меняет стиль поля
    @discardableResult
    open func validate() -> Bool {
        let result = validationClosure?(text) ?? .valid
        if appearance != .disabled {
            switch result {
            case .success:
                appearance = .normal
                detailText = helpText
            case .failure(let error):
                appearance = .error
                if let description = error.errorDescription {
                    detailText = description
                }
            }
        }
        return result.isValid
    }
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        let editingInsets = textBox.editingTextInsets
        let editingHeight = bounds.height - editingInsets.top - editingInsets.bottom
        rect.origin.y = (editingHeight - rect.height) / 2.0 + editingInsets.top
        rect.origin.x -= Constants.rightPadding
        return rect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.size.width -= (Constants.rightPadding * 2)
        return rect
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.size.width -= (Constants.rightPadding * 2)
        return rect
    }
    
    // MARK: - Private methods
    
    private func setupStyle() {
        borderStyle = .none
        tintColor = .c2
        textColor = .c2
        placeholderColor = .c4
        placeholderFont = .sr16
        font = placeholderFont
        titleFont = .sr14
        detailTextFont = .sr12
        updateAppearance()
    }
    
    private func updateAppearance() {
        updateTextAppearance()
        updateTitleAppearance()
        updateSeparatorAppearance()
        updateHelperLabelAppearance()
    }
    
    private func updateTextAppearance() {
        switch appearance {
        case .normal, .error:
            textColor = .c2
        case .disabled:
            textColor = .c5
        }
    }
    
    private func updateTitleAppearance() {
        switch appearance {
        case .normal:
            titleColor = .c5
            if textBox.state == .empty {
                titleColor = .c2
            }
        case .error:
            titleColor = .c7
        case .disabled:
            titleColor = .c5
        }
    }
    
    private func updateHelperLabelAppearance() {
        switch appearance {
        case .normal, .disabled:
            detailTextColor = .c5
        case .error:
            detailTextColor = .c7
        }
    }
    
    private func updateSeparatorAppearance() {
        switch appearance {
        case .normal, .disabled:
            separatorColor = .c6
            if textBox.state == .placeholder || textBox.state == .textInput {
                separatorColor = .c1
            }
        case .error:
            separatorColor = .c7
        }
    }
}

extension StyledTextField: TextBoxDelegate {

    open func didChangeState(newValue: TextInputState, animated: Bool) {
        updateAppearance()
    }
    
}

public extension StyledTextField {
    
    /// Добавить справа иконку поиска и кнопку очистки поля
    func configureSearchAndClearButton() {
        let clearButton = UIButton(type: .custom)
        let clearImg = UIImage(named: "icClear", in: .current, compatibleWith: nil)
        clearButton.setImage(clearImg, for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        setRigthView(clearButton, for: .text)
        setRigthView(clearButton, for: .textInput)
        
        let searchButton = UIButton(type: .custom)
        let lensImg = UIImage(named: "icSearchLens", in: .current, compatibleWith: nil)
        searchButton.setImage(lensImg, for: .disabled)
        searchButton.isEnabled = false
        setRigthView(searchButton, for: .empty)
        setRigthView(searchButton, for: .placeholder)
    }
    
    /// Добавить кнопку скрытия/показа символов пароля
    func configureSecureTextEntryButton() {
        let showPasswordButton = UIButton(type: .custom)
        let btnImage = UIImage(
            named: isSecureTextEntry ? "icLoginVisibilityOff" : "icLoginVisibility",
            in: .current,
            compatibleWith: nil
        )
        showPasswordButton.setImage(btnImage, for: .normal)
        showPasswordButton.addTarget(self, action: #selector(updateSecureTextEntryButton), for: .touchUpInside)
        setRigthView(showPasswordButton, for: .text)
        setRigthView(showPasswordButton, for: .textInput)
        setRigthView(showPasswordButton, for: .empty)
        setRigthView(showPasswordButton, for: .placeholder)
    }
    
    @objc private func updateSecureTextEntryButton(_ button: UIButton) {
        let firstResponder = isFirstResponder
        if firstResponder { _ = resignFirstResponder() }
        isSecureTextEntry.toggle()
        if firstResponder { _ = becomeFirstResponder() }
        
        let btnImage = UIImage(
            named: isSecureTextEntry ? "icLoginVisibilityOff" : "icLoginVisibility",
            in: .current,
            compatibleWith: nil
        )
        button.setImage(btnImage, for: .normal)
    }
}
