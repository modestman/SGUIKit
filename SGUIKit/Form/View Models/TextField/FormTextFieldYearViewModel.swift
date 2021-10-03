import Foundation
import RxCocoa
import RxSwift
import SGCommonHelpers

/// Вью-модель для ввода года
public final class FormTextFieldYearViewModel: FormTextFieldIntViewModel {
    
    public init(
        title: String?,
        value: BehaviorRelay<Int?>,
        isEnabled: Bool = true,
        minYear: Int = 1000,
        maxYear: Int = Calendar.current.component(.year, from: Date())
    ) {

        let validationVM = ValidationTextFieldViewModel(
            pattern: nil,
            inputMask: "[0000]",
            validator: .closure {
                guard let value = FormTextFieldIntViewModel.fromString($0) else { return .invalid }
                return ValidationResult(value >= minYear && value <= maxYear)
            }
        )

        super.init(
            title: title,
            value: value,
            isEnabled: isEnabled,
            validationModel: validationVM
        )
    }
    
    public init(
        title: String?,
        value: BehaviorRelay<Int?>,
        isEnabled: Bool = true,
        validationClosure: @escaping ((Int?) -> ValidationResult)
    ) {

        let validationVM = ValidationTextFieldViewModel(
            pattern: nil,
            inputMask: "[0000]",
            validator: .closure {
                validationClosure(FormTextFieldIntViewModel.fromString($0))
            }
        )

        super.init(
            title: title,
            value: value,
            isEnabled: isEnabled,
            validationModel: validationVM
        )
    }
}
