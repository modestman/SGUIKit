import UIKit

open class TextField: UITextField {

    /// Контейнер с дополнительными лейблами.
    public let textBox = TextBox()

    private var rightViews = [TextInputState: UIView]()

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

    /// Текст отображаемый под полем ввода.
    @IBInspectable open var detailText: String? {
        get { textBox.detailTextLabel.text }
        set {
            textBox.detailTextLabel.text = newValue
            accessibilityLabel = newValue
        }
    }

    /// Шрифт текста с детальным описанием.
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

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Первичная настройка после инициализации.
    open func commonInit() {
        if let text = super.placeholder {
            super.placeholder = nil
            placeholder = text
        }
        textBox.frame = bounds
        addSubview(textBox)
        setupActions()
        updateState(animated: false)
        adjustsFontForContentSizeCategory = true
        rightViewMode = .always
    }

    // MARK: - Public

    @objc open func clear() {
        if delegate?.textFieldShouldClear?(self) == false { return }
        super.text = nil // в `self.text` обновление текста происходит без анимации
        detailText = nil
        updateState(animated: true)
        sendActions(for: .editingChanged)
    }

    open func setRigthView(_ view: UIView?, for state: TextInputState) {
        rightViews[state] = view
        updateState(animated: false)
    }

    open func rigthView(for state: TextInputState) -> UIView? {
        rightViews[state]
    }
    
    // MARK: - UITextInput
    
    // если размер шрифта у placeholder и text в UITextField отличаются,
    // то высота курсора, а из-за него и всего поля будет меняться.
    // чтобы этого избежать, выставляем высоту курсора равной размеру шрифта placeholderLabel
    override open func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.height = max(textBox.placeholderLabel.font.lineHeight, textBox.detailTextLabel.font.lineHeight)
        return rect
    }

    // MARK: - UITextField

    override open var text: String? {
        didSet { updateState(animated: false) }
    }

    override open var placeholder: String? {
        get { textBox.placeholderLabel.text }
        set { textBox.placeholderLabel.text = newValue }
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds).integral
        return rect.inset(by: textBox.editingTextInsets).integral
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textBox.editingTextInsets).integral
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textBox.editingTextInsets).integral
    }

    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds.inset(by: layoutMargins))
    }

    // MARK: - UIView
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        textBox.frame = bounds
    }

    override open func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        textBox.layoutMargins = layoutMargins
    }

    // MARK: - Private

    private func setupActions() {
        [.editingDidBegin, .editingChanged, .editingDidEnd].forEach {
            addTarget(self, action: #selector(textDidEditing), for: $0)
        }
    }

    @objc private func textDidEditing() {
        updateState(animated: true)
    }

    private func updateState(animated: Bool) {
        let state = TextInputState(hasText: hasText, firstResponder: isFirstResponder)
        rightView = rigthView(for: state)
        textBox.setState(state, animated: animated)
    }
    
}
