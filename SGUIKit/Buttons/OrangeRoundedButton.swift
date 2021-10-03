import UIKit

public final class OrangeRoundedButton: RoundedButton {
    
    // MARK: Properties
    
    override var styleColors: RoundedButton.StyleColors {
        let orange = RoundedButton.StyleColors(
            backgroundColor: .c1,
            shadowColor: .c112,
            backgroundShadowColor: .c808,
            titleColor: .white,
            borderColor: .clear,
            tintColor: .white
        )
        
        let orangeDisabled = RoundedButton.StyleColors(
            backgroundColor: .c4,
            shadowColor: .c808,
            backgroundShadowColor: .clear,
            titleColor: .c5,
            borderColor: .clear,
            tintColor: .white
        )
        
        return isEnabled ? orange : orangeDisabled
    }
}
