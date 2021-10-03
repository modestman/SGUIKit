import RxCocoa
import RxSwift

/// Вью-модель для ввода номера телефона
public final class FormTextFieldPhoneViewModel: FormTextFieldStringViewModel {
 
    public static let defaultValidator: TextValidationClosure = { ValidationResult($0?.count == 10) }
    
    public init(
        title: String?,
        value: BehaviorRelay<String?>,
        isEnabled: Bool = true,
        validationClosure: TextValidationClosure? = defaultValidator
    ) {

        var validator: ValidationTextFieldViewModel.ValidatorType = .none
        if let closure = validationClosure {
            validator = .closure(closure)
        }
        
        let validationVM = ValidationTextFieldViewModel(
            pattern: nil,
            inputMask: CommonValidationPatterns.phoneInputMask,
            validator: validator
        )

        super.init(
            title: title,
            value: value,
            isEnabled: isEnabled,
            keyboardType: .phonePad,
            validationModel: validationVM
        )
    }
}
