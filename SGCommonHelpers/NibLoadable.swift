import UIKit

public protocol NibLoadable: NibRepresentable {}

public extension NibLoadable where Self: UIView {
    
    static func loadFromNib() -> Self {
        let results: [Any] = nib.instantiate(withOwner: self, options: nil)
        for result in results {
            if let view = result as? Self {
                return view
            }
        }
        fatalError("\(self) not found")
    }
    
    func loadFromNib() {
        Bundle(for: Self.self).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    }
}
