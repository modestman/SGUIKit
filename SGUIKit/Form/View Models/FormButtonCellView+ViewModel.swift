import SGCommonHelpers

public extension FormButtonCellView {
    
    /// Вью-модель для конфигурирования вьюхи с двумя лэйблами и кнопкой
    struct ViewModel {
        
        public let title: String?
        public let value: String?
        public let isEnabled: Bool
        public let isDisclosureHidden: Bool
        public let tapAction: VoidClosure?
        
        public init(
            title: String?,
            value: String?,
            isEnabled: Bool = true,
            shouldShowDisclosureIndicator: Bool = false,
            tapAction: VoidClosure? = nil
        ) {
            
            self.title = title
            self.value = value
            self.isEnabled = isEnabled
            isDisclosureHidden = !shouldShowDisclosureIndicator
            self.tapAction = tapAction
        }
    }
}
