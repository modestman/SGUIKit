import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Вьюха с многострочным полем ввода (комментарий)
public final class FormTextView: UIView {
    
    private enum Constants {
        static let titleColor: UIColor = .c5
        static let valueEnabledColor: UIColor = .c2
        static let valueDisabledColor: UIColor = .c5
        static let unselectedBorderColor: UIColor = .c4
        static let selectedBorderColor: UIColor = .c3
        static let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let titleInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 7)
        static let textInsets = UIEdgeInsets(top: 6, left: 16, bottom: 16, right: 16)
        static let minHeight: CGFloat = 104
    }
    
    // MARK: - Private properties
    
    private var disposeBag = DisposeBag()
    private var containerView = UIView()
    private var charactersLimit: TextInputCharactersLimit = .noLimit
    
    // MARK: - Public properties
    
    public private(set) var titleLabel = LabelSR14()
    public private(set) var textView = UITextView()
    public var valueChangedAction: StringClosure?
    
    // MARK: - Fabric method
    
    public static func make(with viewModel: ViewModel) -> FormTextView {
        let view = FormTextView()
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
        titleLabel.text = viewModel.title
        textView.text = viewModel.value.value
        textView.isEditable = viewModel.isEnabled
        textView.textColor = viewModel.isEnabled ? Constants.valueEnabledColor : Constants.valueDisabledColor
        textView.autocorrectionType = viewModel.autocorrectionType
        textView.autocapitalizationType = viewModel.autocapitalizationType
        textView.rx.text.bind(to: viewModel.value).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    
    func commonInit() {
        
        // container
        containerView.borderWidth = 1
        containerView.cornerRadius = 2
        containerView.borderColor = Constants.unselectedBorderColor
        let minHeightConstraint = containerView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: Constants.minHeight)
        minHeightConstraint.priority = .defaultHigh
        addSubview(containerView, activate: [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets.right),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.insets.bottom),
            minHeightConstraint
        ])
        containerView.addGestureRecognizer(
            UITapGestureRecognizer(target: textView, action: #selector(UIView.becomeFirstResponder))
        )
        
        // title
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Constants.titleColor
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        containerView.addSubview(titleLabel, activate: [
            titleLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Constants.titleInsets.left
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Constants.titleInsets.right
            ),
            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Constants.titleInsets.top
            )
        ])
        
        // text view
        textView.delegate = self
        textView.font = .sr16
        textView.isScrollEnabled = false
        textView.textColor = Constants.valueEnabledColor
        textView.tintColor = .c2
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        containerView.addSubview(textView, activate: [
            textView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Constants.textInsets.left
            ),
            textView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Constants.textInsets.right
            ),
            textView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.textInsets.top
            ),
            textView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Constants.textInsets.bottom
            )
        ])
        textView.rx.text.orEmpty.subscribe(onNext: valueChangedAction).disposed(by: disposeBag)
    }

}

extension FormTextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        containerView.borderColor = Constants.selectedBorderColor
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        containerView.borderColor = Constants.unselectedBorderColor
    }
    
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

// MARK: - Rx

public extension Reactive where Base: FormTextView {
    
    var viewModel: Binder<FormTextView.ViewModel> {
        Binder(base) { view, vm in
            view.configure(with: vm)
        }
    }
    
    var text: ControlProperty<String?> {
        base.textView.rx.text
    }
}
