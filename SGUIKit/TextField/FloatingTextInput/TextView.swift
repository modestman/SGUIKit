import UIKit

open class TextView: UITextView {

    /// Контейнер с дополнительными лейблами.
    public let textBox = TextBox()

    var notificationCenter: NotificationCenter { .default }

    /// Заголовок.
    @IBInspectable open var title: String? {
        get { textBox.title }
        set { textBox.title = newValue }
    }

    /// Шрифт заголовка.
    open var titleFont: UIFont? {
        get { textBox.titleLabel.font }
        set { textBox.titleLabel.font = newValue }
    }

    /// Цвет текста заголовка.
    @IBInspectable open var titleColor: UIColor? {
        get { textBox.titleColor }
        set { textBox.titleColor = newValue }
    }

    open var placeholderFont: UIFont? {
        get { textBox.placeholderFont }
        set { textBox.placeholderFont = newValue }
    }

    /// Цвет текста заголовка.
    @IBInspectable open var placeholderColor: UIColor? {
        get { textBox.placeholderLabel.textColor }
        set { textBox.placeholderLabel.textColor = newValue }
    }

    /// Цвет полоски разделителя.
    @IBInspectable open var separatorColor: UIColor? {
        get { textBox.separatorView.backgroundColor }
        set { textBox.separatorView.backgroundColor = newValue }
    }

    /// Текст с детальным описанием.
    @IBInspectable open var detailText: String? {
        get { textBox.detailTextLabel.text }
        set {
            textBox.detailTextLabel.text = newValue
            accessibilityLabel = newValue
        }
    }

    /// Шрифт текст с детальным описанием.
    open var detailTextFont: UIFont? {
        get { textBox.detailTextLabel.font }
        set { textBox.detailTextLabel.font = newValue }
    }

    /// Цвет текст с детальным описанием.
    @IBInspectable open var detailTextColor: UIColor? {
        get { textBox.detailTextLabel.textColor }
        set { textBox.detailTextLabel.textColor = newValue }
    }
    
    // MARK: - Init

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    /// Первичная настройка после `init`.
    open func commonInit() {
        textContainer.lineFragmentPadding = 0
        textBox.frame = bounds
        addSubview(textBox)
        observerNotifications()
        updateState(animated: false)
    }

    // MARK: - UITextView

    override open var text: String! {
        didSet { updateState(animated: false) }
    }

    // MARK: - UIView

    override open func layoutSubviews() {
        super.layoutSubviews()
        textBox.frame = bounds
        textContainerInset = textBox.editingTextInsets
    }

    // MARK: - Private

    /// Начать наблюдение за уведомлениями.
    private func observerNotifications() {
        observe(UITextView.textDidBeginEditingNotification, #selector(textDidEditing))
        observe(UITextView.textDidChangeNotification, #selector(textDidEditing))
        observe(UITextView.textDidEndEditingNotification, #selector(textDidEditing))
    }

    private func observe(_ name: NSNotification.Name, _ selector: Selector) {
        notificationCenter.addObserver(self, selector: selector, name: name, object: self)
    }

    @objc private func textDidEditing() {
        updateState(animated: true)
    }

    private func updateState(animated: Bool) {
        let state = TextInputState(hasText: hasText, firstResponder: isFirstResponder)
        textBox.setState(state, animated: animated)
    }
}
