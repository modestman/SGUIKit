import UIKit

public typealias KeyboardUpdateClosure = (KeyboardUpdate) -> Void

/// Уведомляет подписчиков о событиях клавиатуры
public protocol KeyboardObservable: AnyObject {
    
    /// Добавляется на корневую view контроллера при подписке на события клавиатуры.
    /// При срабатывании закрывает клавиатуру при нажатии на область вне поля ввода.
    var closeKeyboardGesture: UITapGestureRecognizer? { get }
    
    /// Анимированно изменяет константу констрейнта при событии скрытия/показа клавиатуры
    ///
    /// Адаптер для метода
    /// ````
    /// bindKeyboardFrame(to constraint: NSLayoutConstraint, margin: CGFloat)
    /// ````
    /// - Parameter constraint: Констрейнт к которому будут применены изменения
    func bindKeyboardFrame(to constraint: NSLayoutConstraint)
    
    /// Анимированно изменяет константу констрейнта при событии скрытия/показа клавиатуры
    ///
    /// - Parameters:
    ///   - constraint: Констрейнт к которому будут применены изменения
    ///   - margin: Отступ, будет добавляться к высоте клавиатуры при показе
    func bindKeyboardFrame(to constraint: NSLayoutConstraint, margin: @escaping () -> CGFloat)
    
    /// Вызывает замыкание при событии скрытия/показа клавиатуры
    func bindKeyboardFrame(animated: Bool, to action: @escaping KeyboardUpdateClosure)
    
    /// Изменяет scrollView.contentInset при открытии клавиатуры
    func bindKeyboardFrame(to scrollView: UIScrollView, margin: @escaping () -> CGFloat)
    
    /// Отписка вручную от событий клавиатуры, т.к.
    /// если несколько экранов с bindKeyboardFrame показываются
    /// друг за другом, ломается их анимация появления/скрытия.
    func unbindKeyboardFrame()
    
    func setupCloseKeyboardGesture()
    func setupCloseKeyboardGesture(ignores subviews: [UIView]?)
    func setupCloseKeyboardGesture(view: UIView?)
    func setupCloseKeyboardGesture(view: UIView?, ignores subviews: [UIView]?)
}

public extension KeyboardObservable {
    
    func setupCloseKeyboardGesture() {
        setupCloseKeyboardGesture(view: nil, ignores: nil)
    }
    
    func setupCloseKeyboardGesture(view: UIView?) {
        setupCloseKeyboardGesture(view: view, ignores: nil)
    }
    
    func setupCloseKeyboardGesture(ignores subviews: [UIView]?) {
        setupCloseKeyboardGesture(view: nil, ignores: subviews)
    }
}
