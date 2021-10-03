import UIKit

/// Вьюха для создания пустого пространства в верстке
public final class FormSpacerView: UIView {
    
    public init(height: CGFloat = 16.0) {
        super.init(frame: .zero)
        commonInit(height: height)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(height: CGFloat = 16.0) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
}
