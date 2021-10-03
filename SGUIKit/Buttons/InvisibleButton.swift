import UIKit

/// Прозрачная кнопка с затенением при нажатии
public final class InvisibleButton: UIButton {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureAppearance()
    }
    
    private func configureAppearance() {
        setBackgroundImage(nil, for: .normal)
        backgroundColor = .clear
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUp), for: .touchCancel)
    }
    
    @objc private func touchDown() {
        backgroundColor = .c6
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .clear
        }
    }
}
