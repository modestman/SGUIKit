import SGCommonHelpers
import UIKit

/// Текст-вью со вспылвающим заголовком
open class StyledTextView: TextView, Validatable {
    
    // MARK: - Types
    
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
    
    override open var text: String! {
        didSet {
            super.text = text
            layoutSubviews()
        }
    }
    
    /// Текст отображемый под полем ввода, если нет ошибки
    open var helpText: String? {
        didSet {
            if isValid { detailText = helpText }
        }
    }
    
    override open var isEditable: Bool {
        didSet {
            if isEditable {
                appearance = .normal
            } else {
                appearance = .disabled
            }
        }
    }
    
    open var isEnabled: Bool {
        set {
            isEditable = newValue
        }
        get {
            isEditable
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
    
    // MARK: - Text Field override
    
    override open func commonInit() {
        super.commonInit()
        isScrollEnabled = false
        textBox.delegate = self
        setupStyle()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        var insets = textBox.editingTextInsets
        insets.top += 2
        insets.bottom -= 2
        textContainerInset = insets
    }
    
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        validate()
        return super.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func setupStyle() {
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
        updateTitleAppearance()
        updateSeparatorAppearance()
        updateTextAppearance()
        updateHelperLabelAppearance()
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
    
    private func updateTextAppearance() {
        switch appearance {
        case .normal, .error:
            textColor = .c2
            isSelectable = true
        case .disabled:
            textColor = .c5
            isSelectable = false
        }
    }
}

extension StyledTextView: TextBoxDelegate {

    open func didChangeState(newValue: TextInputState, animated: Bool) {
        updateAppearance()
    }
    
}
