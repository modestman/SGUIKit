import UIKit

/// View, используемая как subview в XIB
open class XIBView: UIView, NibLoadable {
    
    /// Корневая view, необходимо проставить в XIB'е
    @IBOutlet public var contentView: UIView!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
        addSubview(contentView, with: self)
    }
    
}
