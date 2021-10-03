import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Вьюха с лэйблом и переключателем (UISwitch)
public final class FormSwitchView: ViewWithSeparator {

    private enum Constants {
        static let titleColor: UIColor = .c2
        static let switchColor: UIColor = .c1
        static let insets = UIEdgeInsets(top: 25, left: 16, bottom: 8, right: 16)
        static let horizontalSpacing: CGFloat = 16
        static let titleMinHeight: CGFloat = 24
    }
    
    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public properties
    
    public private(set) var titleLabel = LabelSR16()
    public private(set) var switchControl = UISwitch()
    public var valueChangedAction: BoolClosure?
    
    // MARK: - Fabric method
    
    public static func make(with viewModel: ViewModel) -> FormSwitchView {
        let view = FormSwitchView()
        view.configure(with: viewModel)
        return view
    }
    
    // MARK: - Public methods
    
    public func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        switchControl.isOn = viewModel.value.value
        switchControl.isEnabled = viewModel.isEnabled
        switchControl.rx.isOn.bind(to: viewModel.value).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    
    override func commonInit() {
        hasExtraBottomSpace = true
        super.commonInit()
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Constants.titleColor
        addSubview(titleLabel, activate: [
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleMinHeight),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            titleLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -Constants.insets.bottom)
        ])
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 500), for: .horizontal)
        
        switchControl.onTintColor = Constants.switchColor
        switchControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        addSubview(switchControl, activate: [
            switchControl.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: Constants.horizontalSpacing
            ),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets.right),
            switchControl.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    @objc private func valueChanged() {
        valueChangedAction?(switchControl.isOn)
    }
}

// MARK: - Rx

public extension Reactive where Base: FormSwitchView {
    
    var viewModel: Binder<FormSwitchView.ViewModel> {
        Binder(base) { view, vm in
            view.configure(with: vm)
        }
    }
    
    var isOn: ControlProperty<Bool> {
        base.switchControl.rx.isOn
    }
}
