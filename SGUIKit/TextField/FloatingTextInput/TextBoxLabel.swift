import UIKit

internal final class TextBoxLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        adjustsFontForContentSizeCategory = true
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        // Даже без текста сохраняет высоту.
        return CGSize(width: size.width, height: font.lineHeight.rounded())
    }
}
