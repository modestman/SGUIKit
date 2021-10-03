import UIKit

public extension UIToolbar {
    
    /// Создать тулбар с кнопкой скрытия клавиатуры
    ///
    /// - Parameter target: вьюха, которой будет отправлено событие `endEditing`
    static func makeHideKeyboardToolbar(target: UIView) -> UIToolbar {
        let width = UIScreen.main.bounds.size.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        toolbar.tintColor = .c2
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let image = UIImage(named: "icHideKeyboard", in: .current, compatibleWith: nil)
        let doneButton = UIBarButtonItem(
            image: image,
            style: .done,
            target: target,
            action: #selector(UIView.endEditing(_:))
        )
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
    /// Создать тулбар высотой 44пкс и шириной с размер экрана
    ///
    /// - Parameters:
    ///   - doneTitle: заголовок кнопки закрытия
    ///   - target: таргет для выполнения экшена на кнопке закрытия
    ///   - selector: экшен на кнопке закрытия
    static func makeToolbar(doneTitle: String, target: AnyObject, selector: Selector) -> UIToolbar {
        let width = UIScreen.main.bounds.size.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: doneTitle,
            style: .plain,
            target: target,
            action: selector
        )
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
}
