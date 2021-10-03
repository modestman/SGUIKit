import SGCommonHelpers
import UIKit

open class RoundedButton: UIButton {
    
    // MARK: Types
    
    struct StyleColors {
        var backgroundColor: UIColor
        var shadowColor: UIColor
        var backgroundShadowColor: UIColor
        var titleColor: UIColor
        var borderColor: UIColor
        var tintColor: UIColor
    }
    
    // MARK: Properties
    
    var hitEdgeInsets = UIEdgeInsets()
    
    private var shadowLayer = CAShapeLayer()
    private var backgroundShadowLayer = CAShapeLayer()
    
    var styleColors: StyleColors {
        StyleColors(
            backgroundColor: .white,
            shadowColor: .clear,
            backgroundShadowColor: .clear,
            titleColor: .c1,
            borderColor: .c6,
            tintColor: .c1
        )
    }
    
    // MARK: Override
    
    override open var isHighlighted: Bool {
        get {
            super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            alpha = newValue ? 0.9 : 1
            setupColors()
            setupShadowLayers()
        }
    }
    
    override open var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            super.isEnabled = newValue
            
            shadowLayer.removeFromSuperlayer()
            backgroundShadowLayer.removeFromSuperlayer()
            setupColors()
            setupShadowLayers()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupShadowLayers()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(.c0, for: .normal)
        backgroundColor = UIColor.clear
        titleLabel?.font = .sm12
        setupColors()
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitEdgeInsets == .zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        
        let hitFrame = bounds.inset(by: hitEdgeInsets)
        
        return hitFrame.contains(point)
    }
    
    // MARK: Private
    
    private func setupShadowLayers() {
        backgroundShadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        backgroundShadowLayer.fillColor = UIColor.clear.cgColor
        
        let style = styleColors
        
        let bgShadowColor = style.backgroundShadowColor
        backgroundShadowLayer.shadowColor = bgShadowColor.cgColor
        backgroundShadowLayer.shadowPath = backgroundShadowLayer.path
        backgroundShadowLayer.shadowOffset = CGSize(width: 0, height: 3.0)
        backgroundShadowLayer.shadowRadius = 3
        backgroundShadowLayer.shadowOpacity = 1
        
        if layer.sublayers?.contains(backgroundShadowLayer) == false {
            layer.insertSublayer(backgroundShadowLayer, at: 0)
        }
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        let fillColor = style.backgroundColor
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.lineWidth = 2
        shadowLayer.strokeColor = borderColor?.cgColor
        
        let shadowColor = style.shadowColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4.0)
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOpacity = 1
        
        if layer.sublayers?.contains(shadowLayer) == false {
            layer.insertSublayer(shadowLayer, at: 1)
        }
        
        for view in subviews where view is UIImageView {
            bringSubviewToFront(view)
        }
    }
    
    private func setupColors() {
        let style = styleColors
        setTitleColor(style.titleColor, for: .normal)
        borderColor = style.borderColor
        tintColor = style.tintColor
    }
    
}
