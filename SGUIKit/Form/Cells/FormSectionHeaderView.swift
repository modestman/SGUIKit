import SGCommonHelpers
import UIKit

/// Вьюха с заголовком секции
public final class FormSectionHeaderView: UIView {
    
    private enum Constants {
        static let titleColor: UIColor = .c2
        static let backgroundColor: UIColor = .c6
        static let insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        static let bottomInset: CGFloat = 16
        static let titleMinHeight: CGFloat = 16
    }
    
    // MARK: - Private properties
    
    private let containerView = UIView()
    
    // MARK: - Public properties
    
    public private(set) var titleLabel = LabelSM14()
    
    @IBInspectable
    public var title: String? {
        set {
            configure(with: newValue)
        }
        get {
            titleLabel.text
        }
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
    
    public static func make(with title: String?) -> FormSectionHeaderView {
        let view = FormSectionHeaderView()
        view.configure(with: title)
        return view
    }
    
    // MARK: - Public methods
    
    public func configure(with title: String?) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        containerView.backgroundColor = Constants.backgroundColor
        addSubview(containerView, activate: [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomInset)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Constants.titleColor
        containerView.addSubview(titleLabel, activate: [
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.insets.left),
            titleLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Constants.insets.right
            ),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.insets.top),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.insets.bottom),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleMinHeight)
        ])
    }
}
