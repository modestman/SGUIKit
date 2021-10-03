import Foundation

/// Тип описывающий результат валидации значения введенного пользователем
public enum ValidationResult: Equatable {
    case success
    case failure(ValidationError)
    
    public init(_ bool: Bool) {
        self = bool ? .valid : .invalid
    }
    
    public var isValid: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public static var valid = ValidationResult.success
    public static var invalid = ValidationResult.failure(.unspecified)
    
    public static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.success, .failure),
             (.failure, .success):
            return false
        case (.failure(let lerr), .failure(let rerr)):
            return lerr == rerr
        }
    }
}

/// Тип описывающий ошибку валидации
public struct ValidationError: LocalizedError, Equatable {
    
    /// Описание ошибки
    public var errorDescription: String?
    
    public init(_ description: String?) {
        errorDescription = description
    }
    
    public init() {
        errorDescription = nil
    }
    
    /// Ошибка без описания
    public static let unspecified = ValidationError()
}
