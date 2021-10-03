import UIKit

public class RMRLabel: UILabel {

    public class var rmrFont: UIFont {
        UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    private class func rmr_prepareAppearence(label: UILabel) {
        label.font = rmrFont
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        RMRLabel.rmr_prepareAppearence(label: self)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        font = type(of: self).rmrFont
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        font = type(of: self).rmrFont
    }
}
