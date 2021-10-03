import UIKit

public extension UINib {
    
    /// Согласно документации, так должен работать оригинальный метод nibWithNibName:bundle
    /// Однако, он возвращает некоторую сущность, несмотря на отсутствие в bundle nib с указанным именем.
    /// Пришлось реализовать обертку.
    class func rmrNib(withNibName name: String?, bundle bundleOrNil: Bundle?) -> UINib? {
        let bundle = bundleOrNil ?? Bundle.main
        guard
            let name = name,
            !name.isEmpty,
            bundle.path(forResource: name, ofType: "nib") != nil
        else {
            return nil
        }
        return UINib(nibName: name, bundle: bundle)
    }
    
    class func nib(withClass className: AnyClass) -> UINib? {
        let bundle = Bundle(for: className)
        let name = String(describing: className)
        guard bundle.path(forResource: name, ofType: "nib") != nil else { return nil }
        return UINib(nibName: name, bundle: bundle)
    }
    
}
