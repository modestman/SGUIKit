import UIKit

/// Структура описывающая фрейм и анимацию при появлении или скрытии клавиатуры
public struct KeyboardUpdate {

    /// Время анимации
    public let duration: TimeInterval
    
    /// Опции анимации
    public let options: UIView.AnimationOptions
    
    /// Высота клавиатуры
    public let padding: CGFloat
    
    /// Открывается клавиатура или закрывается
    public var isOpeningKeyboard: Bool { padding > 0 }

    public init?(notification: Notification) {
        guard
            let userInfo = (notification as NSNotification).userInfo as? [String: Any]
        else {
            return nil
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let keyboardEndFrame =
              (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            return nil
        }

        let padding = KeyboardUpdate.paddingForFrame(keyboardEndFrame)
        let options = UIView.AnimationOptions(rawValue: (animationCurve as UInt) << 16)

        self.duration = duration
        self.options = options
        self.padding = padding
    }

    private static func paddingForFrame(_ frame: CGRect) -> CGFloat {
        let endYPosition = frame.origin.y
        let keyboardHeight = frame.height
        let windowHeight = UIApplication.shared.windows.first { $0.isKeyWindow }!.frame.height
        let padding = endYPosition >= windowHeight ? 0.0 : keyboardHeight
        return padding
    }

}
