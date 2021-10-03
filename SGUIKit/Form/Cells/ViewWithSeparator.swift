import UIKit

/// Вьюха с сепаратором внизу
open class ViewWithSeparator: UIView {
    
    private enum Constants {
        static let leftInset: CGFloat = 16
        static let width: CGFloat = 2
        static let color: UIColor = .c6
        static let bootmInset: CGFloat = 26
    }
    
    // MARK: - Public properties
    
    public private(set) var separator = UIView()
    
    public var separatorIsHidden: Bool = false {
        didSet {
            separator.isHidden = separatorIsHidden
        }
    }
    
    /// Необходимо ли добавлять дополнительный отсуп под сепаратором (как у TextField с подсказкой)
    public internal(set) var hasExtraBottomSpace: Bool = false
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Intenal methods
    
    func commonInit() {
        separator.backgroundColor = Constants.color
        let bottom = hasExtraBottomSpace ? -Constants.bootmInset : 0
        addSubview(separator, activate: [
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leftInset),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: Constants.width),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom)
        ])
    }
}
