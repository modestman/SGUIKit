import Foundation

/// Ограничение количества символов разрешенных для ввода в текстовое поле
public enum TextInputCharactersLimit {
    case noLimit
    case limit(count: Int)
}
