import Foundation

// Класс для поиска фреймворк-бандла
final class SGUIKitDummyClass {}

extension Bundle {
    
    static var current: Bundle {
        Bundle(for: SGUIKitDummyClass.self)
    }
}
