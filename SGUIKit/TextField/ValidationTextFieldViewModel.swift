import Foundation
import SGCommonHelpers

/// Модель для настройки ValidationTextField
public struct ValidationTextFieldViewModel {
    
    public enum ValidatorType {
        
        /// Проверка введенного значения по регулярнму выражению
        case regexp(String)
        
        /// Замыкание для проверки
        case closure(TextValidationClosure)
        
        /// Без валидации
        case none
    }
    
    public let pattern: String?
    public let inputMask: String?
    public let validator: ValidatorType
    
    /// - Parameters:
    ///   - pattern: Регулярное выражение по которому проверяются разрешенные для ввода символы.
    ///     Символы, которые не проходят валидацию, будут автоматически вырезатся.
    ///   - inputMask: Маска для форматирования текста
    ///   - validator: Способ проверки валидности введенной строки
    public init(pattern: String? = nil, inputMask: String? = nil, validator: ValidatorType = .none) {
        self.pattern = pattern
        self.inputMask = inputMask
        self.validator = validator
    }
    
    public static let none = ValidationTextFieldViewModel()
}

public extension ValidationTextFieldViewModel {
    
    /// Проверка ввода расстояния (пробег, км)
    /// Максимальное количество символов: 7; число должно быть больше или равно 0
    static let mileage = ValidationTextFieldViewModel(
        pattern: "^\\d{0,7}$",
        inputMask: nil,
        validator: .closure {
            guard
                let value = $0?.replacingOccurrences(of: " ", with: ""),
                let intValue = Int(value)
            else { return .invalid }
            return ValidationResult(intValue >= 0)
        }
    )
    
    /// Проверка гос. номера автомобиля
    static let licensePlate = ValidationTextFieldViewModel(
        pattern: CommonValidationPatterns.licensePlateInputPattern,
        inputMask: "[__________]",
        validator: .regexp(CommonValidationPatterns.licensePlateRegexp)
    )
    
    /// Проверка VIN автомобиля
    static let vin = ValidationTextFieldViewModel(
        pattern: CommonValidationPatterns.vinInputPattern,
        inputMask: "[_________________]",
        validator: .regexp(CommonValidationPatterns.vinRegexp)
    )
    
    /// Проверка номера ПТС
    static let vehicleLicense = ValidationTextFieldViewModel(
        pattern: CommonValidationPatterns.vehicleLicenseInputPattern,
        inputMask: nil,
        validator: .regexp(CommonValidationPatterns.vehicleLicenseRegexp)
    )
    
    /// Проверка на не пустой текст
    static let notEmptyText = ValidationTextFieldViewModel(
        pattern: nil,
        inputMask: nil,
        validator: .closure { ValidationResult(!$0.isNilOrEmpty) }
    )
    
    /// Ограничение количества сиволов
    static func limitLength(min: Int, max: Int) -> ValidationTextFieldViewModel {
        ValidationTextFieldViewModel(
            pattern: "^.{0,\(max)}$",
            validator: .closure { ValidationResult(($0 ?? "").count >= min && ($0 ?? "").count <= max) }
        )
    }
}
