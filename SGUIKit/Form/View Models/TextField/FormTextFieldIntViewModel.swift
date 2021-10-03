import RxCocoa
import RxSwift

/// Вью-модель для ввода целых чисел
public class FormTextFieldIntViewModel: BaseFormTextFieldViewModel<Int?> {
    
    public static var fromString: (String?) -> Int? = {
        guard let value = $0 else { return nil }
        return Int(value)
    }
    
    public static var toString: (Int?) -> String? = {
        guard let value = $0 else { return nil }
        return "\(value)"
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
            toStringMap: FormTextFieldIntViewModel.toString,
            fromStringMap: FormTextFieldIntViewModel.fromString,
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
                validationClosure(FormTextFieldIntViewModel.fromString(text))
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
