import RxCocoa
import SGCommonHelpers

public extension FormSwitchView {
    
    /// Вью-модель для конфигурирования вьюхи с лэйблом и переключателем (UISwitch)
    struct ViewModel {
        
        public let title: String?
        public let value: BehaviorRelay<Bool>
        public let isEnabled: Bool
        
        public init(
            title: String?,
            value: BehaviorRelay<Bool>,
            isEnabled: Bool = true
        ) {
            
            self.title = title
            self.value = value
            self.isEnabled = isEnabled
        }
    }
}
