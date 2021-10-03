import Foundation
import RxCocoa
import RxSwift
import SGCommonHelpers

/// Вью-модель для ввода вещественных чисел
public class FormTextFieldDoubleViewModel: BaseFormTextFieldViewModel<Double?> {
    
    public init(
        title: String?,
        value: BehaviorRelay<Double?>,
        formatter: NumberFormatter,
        isEnabled: Bool = true,
        validationClosure: ((Double?) -> ValidationResult)? = nil
    ) {

        let fromString: (String?) -> Double? = {
            guard let value = $0 else { return nil }
            return formatter.number(from: value)?.doubleValue
        }
        let toString: (Double?) -> String? = {
            guard let value = $0 else { return nil }
            return formatter.string(from: NSNumber(value: value))
        }

        var validator: ValidationTextFieldViewModel.ValidatorType = .none
        if let validationClosure = validationClosure {
            validator = .closure { text in
                validationClosure(fromString(text))
            }
        }

        let validationVM = ValidationTextFieldViewModel(
            pattern: CommonValidationPatterns.floatNumberInputPattern,
            inputMask: nil,
            validator: validator
        )

        super.init(
            title: title,
            value: value,
            toStringMap: toString,
            fromStringMap: fromString,
            isEnabled: isEnabled,
            keyboardType: .decimalPad,
            autocapitalizationType: .none,
            validationModel: validationVM
        )
    }
    
}
