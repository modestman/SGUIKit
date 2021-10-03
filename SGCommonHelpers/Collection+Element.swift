import Foundation

// Добавляет безопастный доступ к эленменту колекции по индексу
public extension Collection where Index == Int {
    
    func element(at index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
}
