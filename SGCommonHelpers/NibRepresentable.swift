import UIKit

public protocol NibRepresentable: AnyObject {
    
    static var className: String { get }
    
    static var nib: UINib { get }
}

public extension NibRepresentable {
    
    static var className: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: className, bundle: Bundle(for: self))
    }
}
