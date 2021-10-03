import Foundation
import RxCocoa
import SGCommonHelpers
import UIKit

public extension FormDatePickerView {
    
    /// Вью-модель для конфигурирования контрола выбора даты
    struct ViewModel {
        
        public let title: String?
        public let value: BehaviorRelay<Date?>
        public let minDate: Date?
        public let maxDate: Date?
        public let dateMode: UIDatePicker.Mode
        public let dateFormatter: DateFormatter
        public let isEnabled: Bool
        
        // Нужно ли вызывать событие обновления даты, когда пользователь прокручивает барабан дата-пикера
        public let shouldUpdateWhileScrolling: Bool
        
        public let validationClosure: ((Date?) -> ValidationResult)?
        
        public init(
            title: String?,
            value: BehaviorRelay<Date?>,
            minDate: Date? = nil,
            maxDate: Date? = nil,
            dateFormatter: DateFormatter,
            dateMode: UIDatePicker.Mode = .date,
            isEnabled: Bool = true,
            shouldUpdateWhileScrolling: Bool = false,
            validationClosure: ((Date?) -> ValidationResult)? = nil
        ) {
            
            self.title = title
            self.value = value
            self.minDate = minDate
            self.maxDate = maxDate
            self.dateFormatter = dateFormatter
            self.dateMode = dateMode
            self.isEnabled = isEnabled
            self.shouldUpdateWhileScrolling = shouldUpdateWhileScrolling
            self.validationClosure = validationClosure
        }
    }
}
