import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Вьюха с однострочным полем ввода и валидацией значения
public final class FormTextFieldView: UIView {
    
    private enum Constants {
        static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        static let height: CGFloat = 88
    }
    
    // MARK: - Private properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Public properties
    
    public private(set) var textField = ValidationTextField()
    public var valueChangedAction: OptionalStringClosure?
    public var helpText: String? {
        set {
            textField.helpText = newValue
        }
        get {
            textField.helpText
        }
    }
    
    // MARK: - Fabric method
    
    public static func make<T>(with viewModel: T) -> FormTextFieldView where T: FormTextFieldConfigurable {
        let view = FormTextFieldView()
        view.configure(with: viewModel)
        return view
    }
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Public methods
    
    public func configure<T>(with viewModel: T) where T: FormTextFieldConfigurable {
        textField.title = viewModel.title
        textField.isEnabled = viewModel.isEnabled
        textField.keyboardType = viewModel.keyboardType
        textField.autocapitalizationType = viewModel.autocapitalizationType
        if let validationModel = viewModel.validationModel {
            textField.configure(with: validationModel)
        }
        textField.text = viewModel.initialTextValue
        if let value = viewModel.initialTextValue {
            if viewModel.validationModel?.inputMask != nil {
                textField.maskDelegate.put(text: value, into: textField)
            }
            textField.validate()
        }
        textField.cleanText.skip(1).bind(to: viewModel.textValue).disposed(by: disposeBag)
        textField.cleanText.subscribe(onNext: valueChangedAction).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    
    func commonInit() {
        addSubview(textField, activate: [
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets.right),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.insets.bottom),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.height)
        ])
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.cleanText.subscribe(onNext: valueChangedAction).disposed(by: disposeBag)
    }
    
}

// MARK: - Rx

public extension Reactive where Base: FormTextFieldView {
    
    var text: Observable<String?> {
        base.textField.cleanText.asObservable()
    }
}
