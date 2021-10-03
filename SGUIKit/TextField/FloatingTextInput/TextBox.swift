import UIKit

public final class TextBox: UIView {

    public private(set) var state = TextInputState.placeholder

    public weak var delegate: TextBoxDelegate?
    
    var title: String? {
        didSet {
            titleLabel.text = title
            titlePlaceholderLabel.text = title
        }
    }

    var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
            titlePlaceholderLabel.textColor = titleColor
        }
    }

    var placeholderFont: UIFont? {
        didSet {
            titlePlaceholderLabel.font = placeholderFont
            placeholderLabel.font = placeholderFont
        }
    }

    let titleLabel: UILabel = TextBoxLabel(fontSize: UIFont.smallSystemFontSize)
    let titlePlaceholderLabel: UILabel = TextBoxLabel()
    let placeholderLabel: UILabel = TextBoxLabel()
    let detailTextLabel: UILabel = TextBoxLabel(fontSize: UIFont.smallSystemFontSize)
    let separatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 2))
        view.backgroundColor = UIColor.systemGray3
        return view
    }()

    /// Высота тайтла
    private let titleHeight: CGFloat = 20
    
    /// Высота подсказки
    private let detailTextHeight: CGFloat = 18
    
    /// Отступ от тайтла до верхнего края вьюхи
    private let titleTopSpace: CGFloat = 4
    
    /// Отступ от тайтла до основного текста
    private let titleBottomSpace: CGFloat = 4
    
    /// Отступ от сепаратора до основного текста
    private let separatorTopSpace: CGFloat = 8
    
    /// Отступ от подсказки до сепаратора
    private let detailTextTopSpace: CGFloat = 4
    
    /// Отступ от подсказки до нижнего края вьюхи
    private let detailTextBottomSpace: CGFloat = 4
    
    /// Время анимации тайтла
    private let animationDuration: TimeInterval = 0.16

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Internal

    /// Отсутпы до фрейма в котором можно редактировать текст.
    public var editingTextInsets: UIEdgeInsets {
        let top = titleHeight + titleTopSpace + titleBottomSpace
        let bottom = separatorView.frame.height + separatorTopSpace +
            detailTextTopSpace + detailTextBottomSpace + detailTextHeight

        return UIEdgeInsets(
            top: top,
            left: layoutMargins.left,
            bottom: bottom,
            right: layoutMargins.right
        )
    }

    func setState(_ newState: TextInputState, animated: Bool) {
        guard newState != state else {
            return
        }
        
        delegate?.willChangeState(newValue: newState, animated: animated)
        let didChage = { [weak self] () -> Void in
            self?.delegate?.didChangeState(newValue: newState, animated: animated)
        }
        
        let oldSate = state
        state = newState
        let isAnimated = animated && window != nil && frame != .zero

        switch (oldSate, newState, isAnimated) {
        case (_, .empty, true):
            moveTitleDown(completion: didChage)
        case (.empty, .placeholder, true):
            moveTitleUp(completion: didChage)
        default:
            stateDidUpdate()
            didChage()
        }
    }

    // MARK: - Private

    private func commonInit() {
        isUserInteractionEnabled = false
        let subviews = [
            titleLabel,
            titlePlaceholderLabel,
            placeholderLabel,
            detailTextLabel,
            separatorView
        ]
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.isUserInteractionEnabled = false
            addSubview(subview)
        }
        setupConstraints()
        setupAccessibilities()
    }

    private func setupConstraints() {
        layoutMargins = .zero
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: titleTopSpace),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleHeight),
            
            titlePlaceholderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleBottomSpace),
            titlePlaceholderLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titlePlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: titlePlaceholderLabel.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: separatorView.frame.height),
            separatorView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
//            separatorView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            detailTextLabel.heightAnchor.constraint(equalToConstant: detailTextHeight),
            detailTextLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: detailTextTopSpace),
            detailTextLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            detailTextLabel.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor,
                constant: -detailTextBottomSpace
            )
        ])
    }

    private func debug() {
        title = "Title"
        placeholderLabel.text = "Placeholder"
        detailTextLabel.text = "Detail text"

        titleLabel.backgroundColor = UIColor.red
        placeholderLabel.backgroundColor = UIColor.yellow
        detailTextLabel.backgroundColor = UIColor.green
        separatorView.backgroundColor = UIColor.purple
    }

    private func setupAccessibilities() {
        titleLabel.accessibilityIdentifier = "textBox_title"
        titlePlaceholderLabel.accessibilityIdentifier = "textBox_title_placeholder"
        placeholderLabel.accessibilityIdentifier = "textBox_placeholder"
        detailTextLabel.accessibilityIdentifier = "textBox_detailText"
    }
    
    private func stateDidUpdate() {
        updateTitle()
        updatePlaceholder()
    }

    private func updateTitle() {
        switch state {
        case .empty:
            titleLabel.isHidden = true
            titlePlaceholderLabel.isHidden = false
        case .text, .placeholder, .textInput:
            titleLabel.isHidden = false
            titlePlaceholderLabel.isHidden = true
        }
    }

    private func updatePlaceholder() {
        placeholderLabel.alpha = (state == .placeholder) ? 1 : 0
    }

    private func moveTitleDown(completion: (() -> Void)? = nil) {
        titlePlaceholderLabel.transform = transform(
            from: titleLabel.frame,
            to: titlePlaceholderLabel.frame
        )
        animateTitles(completion: completion)
    }

    private func moveTitleUp(completion: (() -> Void)? = nil) {
        titleLabel.transform = transform(
            from: titlePlaceholderLabel.frame,
            to: titleLabel.frame
        )
        animateTitles(completion: completion)
    }

    private func animateTitles(completion: (() -> Void)? = nil) {
        updateTitle()
        UIView.animate(withDuration: animationDuration) {
            self.titleLabel.transform = .identity
            self.titlePlaceholderLabel.transform = .identity
            self.updatePlaceholder()
            completion?()
        }
    }

    private func transform(from source: CGRect, to destination: CGRect) -> CGAffineTransform {
        let scaleX = source.width / destination.width
        let scaleY = source.height / destination.height

        let translationX = source.origin.x - destination.origin.x - (destination.width * (1.0 - scaleX) / 2)
        let translationY = source.origin.y - destination.origin.y - (destination.height * (1.0 - scaleY) / 2)

        return CGAffineTransform(translationX: translationX, y: translationY).scaledBy(x: scaleX, y: scaleY)
    }
}

public protocol TextBoxDelegate: AnyObject {
    func willChangeState(newValue: TextInputState, animated: Bool)
    func didChangeState(newValue: TextInputState, animated: Bool)
}

public extension TextBoxDelegate {
    // Default implementation
    func willChangeState(newValue: TextInputState, animated: Bool) {}
    func didChangeState(newValue: TextInputState, animated: Bool) {}
}
