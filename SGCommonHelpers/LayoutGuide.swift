import UIKit

/// Обобщенный тип лайаут гайда.
///
/// - Note: Обобщение `UIView` и `UILayoutGuide`.
public protocol LayoutGuide {
    /// Верхний край.
    var topAnchor: NSLayoutYAxisAnchor { get }
    /// Нижний край.
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    /// Правый край.
    var rightAnchor: NSLayoutXAxisAnchor { get }
    /// Левый край.
    var leftAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}

public extension UIView {
    
    /// Добавить сабвью вместе с лайаут гайдом.
    /// ```
    /// final class TextCell: UICollectionViewCell {
    ///     let textLabel = UILabel()
    ///
    ///     override init(frame: CGRect) {
    ///         super.init(frame: frame)
    ///         addSubview(textLabel, with: layoutMarginsGuide)
    ///         // addSubview(textLabel, with: self)
    ///     }
    /// }
    /// ```
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - guide: Гайд, к краям которого будет крепиться вью.
    func addSubview(_ subview: UIView, with guide: LayoutGuide) {
        assert((guide as? UIView) != subview, "Края сабвью не могут быть привазаны к ней же")
        addSubview(subview, activate: [
            subview.topAnchor.constraint(equalTo: guide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            subview.rightAnchor.constraint(equalTo: guide.rightAnchor),
            subview.leftAnchor.constraint(equalTo: guide.leftAnchor)
        ])
    }
    
    /// Добавить сабвью и активировать констрейнты.
    ///
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - constraints: Констрейнты создаются из замыкания после, того как `subview` будет добавлена.
    func addSubview(_ subview: UIView, activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate(constraints())
    }
    
    /// Добавить сабвью по определенному индексу вместе с лайаут гайдом.
    ///
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - index: Индекс, по которому стоит вставить сабвью.
    ///   - guide: Гайд, к краям которого будет крепиться вью.
    func insertSubview(_ subview: UIView, at index: Int, with guide: LayoutGuide) {
        assert((guide as? UIView) != subview, "Края сабвью не могут быть привазаны к ней же")
        insertSubview(subview, at: index, activate: [
            subview.topAnchor.constraint(equalTo: guide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            subview.rightAnchor.constraint(equalTo: guide.rightAnchor),
            subview.leftAnchor.constraint(equalTo: guide.leftAnchor)
        ])
    }
    
    /// Добавить сабвью по определенному индексу и активировать констрейнты.
    ///
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - index: Индекс, по которому стоит вставить сабвью.
    ///   - constraints: Констрейнты создаются из замыкания после, того как `subview` будет добавлена.
    func insertSubview(
        _ subview: UIView,
        at index: Int,
        activate constraints: @autoclosure () -> [NSLayoutConstraint]
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(subview, at: index)
        NSLayoutConstraint.activate(constraints())
    }
    
    /// Добавить сабвью ниже другой вью и активировать констрейнты.
    ///
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - siblingSubview: Вью, которая будет выше вставляемой
    ///   - constraints: Констрейнты создаются из замыкания после, того как `subview` будет добавлена.
    func insertSubview(
        _ subview: UIView,
        belowSubview siblingSubview: UIView,
        activate constraints: @autoclosure () -> [NSLayoutConstraint]
    ) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(subview, belowSubview: siblingSubview)
        NSLayoutConstraint.activate(constraints())
    }
}
