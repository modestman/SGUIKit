import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Вьюха с двумя лэйблами (заголовок и значение) и кнопкой поверх
public final class FormButtonCellView: ViewWithSeparator {
    
    private enum Constants {
        static let titleColor: UIColor = .c5
        static let valueEnabledColor: UIColor = .c2
        static let valueDisabledColor: UIColor = .c5
        static let titleLineHeight: CGFloat = 20
        static let valueLineHeight: CGFloat = 24
        static let insets = UIEdgeInsets(top: 4, left: 16, bottom: 8, right: 16)
        static let spacing: CGFloat = 4
        static let labelTrailingWhenDisclosure: CGFloat = -44
        static let disclosureWidth: CGFloat = 24
    }
    
    // MARK: - Private properties
    
    private var action: VoidClosure?
    private var titleLabelTrailingConstraint: NSLayoutConstraint!
    private var valueLabelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Public properties
    
    public private(set) var titleLabel = LabelSR14()
    public private(set) var valueLabel = LabelSR16()
    public private(set) var button = InvisibleButton()
    public private(set) var disclosureIndicator = UIImageView()
    
    public var isDisclosureIndicatorHidden: Bool {
        set {
            disclosureIndicator.isHidden = newValue
            let labelsTrailing = newValue ? -Constants.insets.right : Constants.labelTrailingWhenDisclosure
            titleLabelTrailingConstraint?.constant = labelsTrailing
            valueLabelTrailingConstraint?.constant = labelsTrailing
        }
        get {
            disclosureIndicator.isHidden
        }
    }
    
    // MARK: - Fabric method
    
    public static func make(with viewModel: ViewModel) -> FormButtonCellView {
        let view = FormButtonCellView()
        view.configure(with: viewModel)
        return view
    }
    
    // MARK: - Public methods
    
    public func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        button.isEnabled = viewModel.isEnabled
        valueLabel.textColor = viewModel.isEnabled ? Constants.valueEnabledColor : Constants.valueDisabledColor
        action = viewModel.tapAction
        isDisclosureIndicatorHidden = viewModel.isDisclosureHidden
        disclosureIndicator.tintColor = viewModel.isEnabled ? .c1 : .c5
    }
    
    // MARK: - Internal methods
    
    override func commonInit() {
        hasExtraBottomSpace = true
        super.commonInit()
        addSubview(button, activate: [
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: separator.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
                        
        addSubview(disclosureIndicator, activate: [
            disclosureIndicator.widthAnchor.constraint(equalToConstant: Constants.disclosureWidth),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: Constants.disclosureWidth),
            disclosureIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets.right)
        ])
        disclosureIndicator.image = UIImage(named: "icChevronRight", in: .current, compatibleWith: nil)
        disclosureIndicator.contentMode = .scaleAspectFit
        
        titleLabel.textColor = Constants.titleColor
        titleLabel.numberOfLines = 0
        
        titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -Constants.insets.right
        )
        
        addSubview(titleLabel, activate: [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleLineHeight),
            titleLabelTrailingConstraint
        ])
        
        valueLabel.numberOfLines = 0
        valueLabelTrailingConstraint = valueLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -Constants.insets.right
        )
        
        addSubview(valueLabel, activate: [
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            valueLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -Constants.insets.bottom),
            valueLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.valueLineHeight),
            valueLabelTrailingConstraint
        ])
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    @objc private func tap() {
        action?()
    }
}

// MARK: - Rx

public extension Reactive where Base: FormButtonCellView {
    
    var viewModel: Binder<FormButtonCellView.ViewModel> {
        Binder(base) { view, vm in
            view.configure(with: vm)
        }
    }
    
    var tap: ControlEvent<Void> {
        base.button.rx.tap
    }
}
