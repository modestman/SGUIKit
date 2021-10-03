import UIKit

final class TransparentBlackButton: RoundedButton {
    
    // MARK: Properties
    
    override var styleColors: RoundedButton.StyleColors {
        let color = UIColor.black.withAlphaComponent(0.5)
        return RoundedButton.StyleColors(
            backgroundColor: color,
            shadowColor: .clear,
            backgroundShadowColor: .clear,
            titleColor: color,
            borderColor: .clear,
            tintColor: .white
        )
    }
    
}
