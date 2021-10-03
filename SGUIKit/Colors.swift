import UIKit

// swiftlint:disable object_literal
public extension UIColor {
    
    // MARK: - Основная палитра
    
    /// #FF6700
    /// #Оранжевый
    class var c1: UIColor {
        UIColor(
            red: 255 / 255.0,
            green: 103 / 255.0,
            blue: 0.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #333333
    class var c2: UIColor {
        UIColor(
            red: 51 / 255.0,
            green: 51 / 255.0,
            blue: 51 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #DBD8BF
    class var c3: UIColor {
        UIColor(
            red: 219.0 / 255.0,
            green: 216.0 / 255.0,
            blue: 191.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #DFDFE6
    class var c4: UIColor {
        UIColor(
            red: 223.0 / 255.0,
            green: 223.0 / 255.0,
            blue: 230.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #BFBFC9
    class var c5: UIColor {
        UIColor(
            red: 191.0 / 255.0,
            green: 191.0 / 255.0,
            blue: 201.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #F7F7FA
    class var c6: UIColor {
        UIColor(
            red: 247.0 / 255.0,
            green: 247.0 / 255.0,
            blue: 250.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #FF0000
    class var c7: UIColor {
        UIColor(
            red: 255.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #000000
    /// #Черный
    class var c8: UIColor {
        UIColor(
            red: 0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #00CC66
    class var c9: UIColor {
        UIColor(
            red: 0.0 / 255.0,
            green: 204.0 / 255.0,
            blue: 102.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #88888F
    class var c10: UIColor {
        UIColor(
            red: 136.0 / 255.0,
            green: 136.0 / 255.0,
            blue: 143.0 / 255.0,
            alpha: 1.0
        )
    }
    
    /// #FFFFFF
    class var c0: UIColor {
        UIColor(
            red: 255.0 / 255.0,
            green: 255.0 / 255.0,
            blue: 255.0 / 255.0,
            alpha: 1.0
        )
    }
    
    // MARK: - Дополнительные цвета
    
    class var c060: UIColor {
        UIColor(
            white: 255.0 / 255.0,
            alpha: 0.6
        )
    }
    
    class var c110: UIColor {
        UIColor(
            red: 255.0 / 255.0,
            green: 103.0 / 255.0,
            blue: 0.0,
            alpha: 0.1
        )
    }
    
    class var c162: UIColor {
        UIColor(
            red: 255.0 / 255.0,
            green: 103.0 / 255.0,
            blue: 0.0,
            alpha: 0.62
        )
    }
    
    class var c360: UIColor {
        UIColor(
            red: 219.0 / 255.0,
            green: 216.0 / 255.0,
            blue: 191.0 / 255.0,
            alpha: 0.6
        )
    }
    
    class var c530: UIColor {
        UIColor(
            red: 223.0 / 255.0,
            green: 223.0 / 255.0,
            blue: 230.0 / 255.0,
            alpha: 0.3
        )
    }
    
    /// #Тень кнопки черная
    class var c808: UIColor {
        UIColor.c8.withAlphaComponent(0.08)
    }
    
    /// #Тень кнопки оранжевая
    class var c112: UIColor {
        UIColor.c1.withAlphaComponent(0.12)
    }
    
}
