import UIKit

public enum FontNames {
    public static let sr = "Stem-Regular"
    public static let sm = "Stem-Medium"
    public static let sl = "Stem-Light"
    public static let nl = "NittiWM2-Light"
    
    static var fileNames: [String] = ["STM45", "STM55", "STM65", "nittiL"]
}

public extension UIFont {
    
    /// Зарегистрировать кастомные шрифты, чтобы они были доступны по имени через UIFont
    static func registerCustomFonts() throws {
        let bundle = Bundle(for: SGUIKitDummyClass.self)
        for font in FontNames.fileNames {
            guard
                let path = bundle.url(forResource: font, withExtension: "otf")
            else { continue }
            
            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterFontsForURL(path as CFURL, .process, &error) else {
                throw error!.takeUnretainedValue()
            }
        }
    }

    class var sr16: UIFont {
        UIFont(name: FontNames.sr, size: 16)!
    }

    class var sr14: UIFont {
        UIFont(name: FontNames.sr, size: 14)!
    }
    
    class var sr12: UIFont {
        UIFont(name: FontNames.sr, size: 12)!
    }

    class var sm20: UIFont {
        UIFont(name: FontNames.sm, size: 20)!
    }
    
    class var sm16: UIFont {
        UIFont(name: FontNames.sm, size: 16)!
    }

    class var sm14: UIFont {
        UIFont(name: FontNames.sm, size: 14)!
    }
    
    class var sm12: UIFont {
        UIFont(name: FontNames.sm, size: 12)!
    }

    class var nl16: UIFont {
        UIFont(name: FontNames.nl, size: 16)!
    }

}
