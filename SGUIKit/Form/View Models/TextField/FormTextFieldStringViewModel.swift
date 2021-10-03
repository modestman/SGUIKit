import RxCocoa
import RxSwift
import UIKit

///  Вью-модель для ввода текста
public class FormTextFieldStringViewModel: BaseFormTextFieldViewModel<String?> {

    public init(
        title: String?,
        value: BehaviorRelay<String?>,
        isEnabled: Bool = true,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        validationModel: ValidationTextFieldViewModel? = nil
    ) {
        
        super.init(
            title: title,
            value: value,
            toStringMap: { $0 },
            fromStringMap: { $0 },
            isEnabled: isEnabled,
            keyboardType: keyboardType,
            autocapitalizationType: autocapitalizationType,
            validationModel: validationModel
        )
    }
    
    public convenience init(
        title: String?,
        value: BehaviorRelay<String?>,
        isEnabled: Bool = true,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        validationClosure: TextValidationClosure? = nil
    ) {
        
        var validationVM: ValidationTextFieldViewModel?
        if let closure = validationClosure {
            validationVM = ValidationTextFieldViewModel(
                pattern: nil,
                inputMask: nil,
                validator: .closure(closure)
            )
        }
        
        self.init(
            title: title,
            value: value,
            isEnabled: isEnabled,
            keyboardType: keyboardType,
            autocapitalizationType: autocapitalizationType,
            validationModel: validationVM
        )
    }
}
