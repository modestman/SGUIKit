import UIKit

/// TextField который запрещает ввод невалидных символов и проверяет значение по окончании ввода.
open class ValidationTextField: MaskedTextField {

    // MARK: - Private properties
    
    private var validationPattern: String?
    
    // MARK: - Public methods
    
    public func configure(with model: ValidationTextFieldViewModel) {
        switch model.validator {
        case .none:
            validationClosure = { _ in .valid }
            
        case .regexp(let modelRegExp):
            validationClosure = { [weak self] _ in
                guard let self = self, let string = self.cleanText.value else { return .invalid }
                let regExp = try? NSRegularExpression(pattern: modelRegExp)
                return ValidationResult(string.checkRegularExpression(regExp))
            }
            
        case .closure(let closure):
            if model.inputMask != nil {
                // Если присутствует маска, то в замыкание для проверки передаём "чистый" текст (без маски)
                validationClosure = { [weak self] _ in
                    closure(self?.cleanText.value)
                }
            } else {
                validationClosure = closure
            }
        }

        if let mask = model.inputMask {
            inputMask = mask
        } else {
            delegate = self
        }
        validationPattern = model.pattern
        textFieldShouldReturnClosure = { textField in
            textField.resignFirstResponder()
            return true
        }
    }
    
    // MARK: - Private methods

    private func cutLastCharacter(_ text: String) -> String {
        let newString = text.substring(to: text.count - 1)
        if textMatchesRegex(newString.withoutWhitespaces) || newString.isEmpty {
            return newString
        }
        return cutLastCharacter(newString)
    }

    private func textMatchesRegex(_ text: String) -> Bool {
        guard let pattern = validationPattern, !text.isEmpty else { return true }

        if let regExp = try? NSRegularExpression(pattern: pattern) {
            return text.checkRegularExpression(regExp)
        }
        return false
    }
    
    // MARK: - Delegate

    // Валидация ввода, если не включена маска
    override public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        if let currentText = textField.text {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if textMatchesRegex(newText) {
                cleanText.accept(newText)
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    // Валидация ввода, если включена маска
    override public func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        
        if autocapitalizationType == .allCharacters {
            textField.text = textField.text?.uppercased()
        }

        guard
            let text = textField.text,
            !textMatchesRegex(value),
            !value.isEmpty
        else {
            cleanText.accept(value)
            return
        }

        let newText = cutLastCharacter(text)
        textField.text = newText
        cleanText.accept(newText.withoutWhitespaces)
    }
}
