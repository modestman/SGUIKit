import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Протокол вью-модели для конфигурирования текстового поля ввода
public protocol FormTextFieldConfigurable {
    
    /// Тип значения
    associatedtype T
    
    /// Заголовок поля ввода
    var title: String? { get }
    
    /// Значение преобразованное в тип T
    var value: BehaviorRelay<T> { get }
    
    /// Текстовое значение введенное в TextField
    var textValue: PublishSubject<String?> { get }
    
    /// Разрешено ли редактирование
    var isEnabled: Bool { get }
    
    /// Тип клавиатуры
    var keyboardType: UIKeyboardType { get }
    
    /// Тип автоматического применения заглавных букв
    var autocapitalizationType: UITextAutocapitalizationType { get }
    
    /// Модель для валидации введенных значений
    var validationModel: ValidationTextFieldViewModel? { get set }
    
    /// Текстовое представление значения, которое нужно установить при конфигурации поля ввода
    var initialTextValue: String? { get }
}

/// Базовый класс вью-модели
public class BaseFormTextFieldViewModel<T>: FormTextFieldConfigurable {
    
    public let title: String?
    public let value: BehaviorRelay<T>
    public let textValue: PublishSubject<String?>
    public let isEnabled: Bool
    public let keyboardType: UIKeyboardType
    public let autocapitalizationType: UITextAutocapitalizationType
    public var validationModel: ValidationTextFieldViewModel?

    private let toStringMap: (T) -> String?
    private let disposeBag = DisposeBag()

    public init(
        title: String?,
        value: BehaviorRelay<T>,
        toStringMap: @escaping (T) -> String?,
        fromStringMap: @escaping (String?) -> T,
        isEnabled: Bool = true,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        validationModel: ValidationTextFieldViewModel? = nil
    ) {

        self.title = title
        self.value = value
        textValue = PublishSubject<String?>()
        self.isEnabled = isEnabled
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.validationModel = validationModel
        self.toStringMap = toStringMap

        textValue.map(fromStringMap).bind(to: value).disposed(by: disposeBag)
    }

    public var initialTextValue: String? {
        toStringMap(value.value)
    }
}
