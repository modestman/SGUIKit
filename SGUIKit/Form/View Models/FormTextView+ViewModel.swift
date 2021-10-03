import RxCocoa
import SGCommonHelpers
import UIKit

public extension FormTextView {
    
    /// Вью-модель для конфигурирования многострочного поля ввода
    struct ViewModel {
        
        public let title: String?
        public let value: BehaviorRelay<String?>
        public let isEnabled: Bool
        public let autocapitalizationType: UITextAutocapitalizationType
        public let autocorrectionType: UITextAutocorrectionType
        
        /// Ограничение количества символов для ввода
        public let charactersLimit: TextInputCharactersLimit

        public init(
            title: String?,
            value: BehaviorRelay<String?>,
            isEnabled: Bool = true,
            autocapitalizationType: UITextAutocapitalizationType = .sentences,
            autocorrectionType: UITextAutocorrectionType = .default,
            charactersLimit: TextInputCharactersLimit = .noLimit
        ) {
            
            self.title = title
            self.value = value
            self.isEnabled = isEnabled
            self.autocapitalizationType = autocapitalizationType
            self.autocorrectionType = autocorrectionType
            self.charactersLimit = charactersLimit
        }
    }
}
