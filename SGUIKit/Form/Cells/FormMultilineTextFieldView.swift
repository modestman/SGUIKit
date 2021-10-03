import RxCocoa
import RxSwift
import UIKit

/// Вьюха с многострочным полем ввода (адрес)
public final class FormMultilineTextFieldView: UIView {
    
    private enum Constants {
        static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    // MARK: - Private properties
    
    private var disposeBag = DisposeBag()
    private var charactersLimit: TextInputCharactersLimit = .noLimit
    
    // MARK: - Public properties
    
    public private(set) var textView = StyledTextView()
    public var valueChangedAction: ((String) -> Void)?
    
    // MARK: - Fabric method
    
    public static func make(with viewModel: ViewModel) -> FormMultilineTextFieldView {
        let view = FormMultilineTextFieldView()
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
    
    public func configure(with viewModel: ViewModel) {
        charactersLimit = viewModel.charactersLimit
        textView.title = viewModel.title
        textView.text = viewModel.value.value
        textView.isEditable = viewModel.isEnabled
        textView.autocapitalizationType = viewModel.autocapitalizationType
        textView.validationClosure = viewModel.validationClosure
        textView.rx.text.bind(to: viewModel.value).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    
    func commonInit() {
        
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.delegate = self
        
        addSubview(textView, activate: [
            textView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.insets.right),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.insets.bottom)
        ])
                
        textView.rx.text.orEmpty.subscribe(onNext: valueChangedAction).disposed(by: disposeBag)
    }
}

extension FormMultilineTextFieldView: UITextViewDelegate {
    
    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard case .limit(let count) = charactersLimit else { return true }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= count
    }
}
