import Foundation

public protocol Validatable {
    
    /// Проверяет введенное значение на валидность и меняет стиль контрола
    @discardableResult func validate() -> Bool
    
}
