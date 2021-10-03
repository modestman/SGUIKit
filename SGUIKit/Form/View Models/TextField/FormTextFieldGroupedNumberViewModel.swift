import RxCocoa
import RxSwift

/// Вью-модель для ввода целых чисел с группировкой по разрядам (1 000 000)
public class FormTextFieldGroupedNumberViewModel: BaseFormTextFieldViewModel<Int?> {
    
    public static var fromString: (String?) -> Int? = {
        guard let value = $0 else { return nil }
        
        return Int(value.replacingOccurrences(of: " ", with: ""))
    }
    
    public static var toString: (Int?) -> String? = {
        guard let value = $0 else { return nil }
        
        return "\(GroupedNumberTextFieldFormatter.format(price: value))"
    }
    
    // MARK: - Init
    
    public init(
        title: String?,
        value: BehaviorRelay<Int?>,
        isEnabled: Bool = true,
        validationModel: ValidationTextFieldViewModel? = nil
    ) {

        super.init(
            title: title,
            value: value,
            toStringMap: FormTextFieldGroupedNumberViewModel.toString,
            fromStringMap: FormTextFieldGroupedNumberViewModel.fromString,
            isEnabled: isEnabled,
            keyboardType: .numberPad,
            autocapitalizationType: .none,
            validationModel: validationModel
        )
    }

    public convenience init(
        title: String?,
        value: BehaviorRelay<Int?>,
        isEnabled: Bool = true,
        validationClosure: ((Int?) -> ValidationResult)? = nil
    ) {
        
        var validator: ValidationTextFieldViewModel.ValidatorType = .none
        if let validationClosure = validationClosure {
            validator = .closure { text in
                validationClosure(FormTextFieldGroupedNumberViewModel.fromString(text))
            }
        }

        let validationVM = ValidationTextFieldViewModel(
            pattern: CommonValidationPatterns.intNumberInputPattern,
            inputMask: nil,
            validator: validator
        )
        
        self.init(title: title, value: value, isEnabled: isEnabled, validationModel: validationVM)
    }
}
