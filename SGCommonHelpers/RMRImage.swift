import UIKit

public extension UIImage {

    class func named(
        _ name: String,
        withRenderingMode renderingMode: UIImage.RenderingMode
    ) -> UIImage? {
        UIImage(named: name)?.withRenderingMode(renderingMode)
    }

    class func templateImage(withName name: String) -> UIImage? {
        named(name, withRenderingMode: .alwaysTemplate)
    }

    class func tintedImage(withName name: String, tintColor: UIColor) -> UIImage? {
        UIImage(named: name)?.tintedImage(withColor: tintColor)
    }

    class func backgroundImage(
        withColor color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1)
    ) -> UIImage {
        UIGraphicsBeginImageContext(size)

        color.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    class func backgroundImage(
        withColor color: UIColor,
        size: CGSize? = .none,
        cornernRadius radius: CGFloat
    ) -> UIImage {
        let size = size ?? CGSize(width: radius * 2, height: radius * 2)

        UIGraphicsBeginImageContext(size)

        let context = UIGraphicsGetCurrentContext()

        color.setFill()
        let path = UIBezierPath(roundedRect: CGRect(size: size), cornerRadius: CGFloat(radius)).cgPath
        context?.addPath(path)
        context?.fillPath()

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    class func resizableImage(
        withColor color: UIColor,
        cornernRadius radius: CGFloat
    ) -> UIImage {
        let side = radius * 2 + 1
        let size = CGSize(width: side, height: side)
        let insets = UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)

        let image =
            backgroundImage(withColor: color, size: size, cornernRadius: radius)
                .resizableImage(withCapInsets: insets, resizingMode: .stretch)

        return image
    }

    class func resizableImage(
        withBorder borderColor: UIColor,
        fillColor: UIColor? = .none,
        lineWidth: CGFloat,
        cornerRadius: CGFloat
    ) -> UIImage {
        let lineWidth = min(lineWidth, cornerRadius)
        let side = cornerRadius * 2 + 1
        let size = CGSize(width: side, height: side)

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(lineWidth)

        if let fillColor = fillColor {
            let fillRect = CGRect(size: size)
            let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: cornerRadius)
            context?.addPath(fillPath.cgPath)

            fillColor.setFill()
            context?.fillPath()
        }

        let borderRectInset = lineWidth / 2.0
        let borderRect = CGRect(size: size).insetBy(dx: borderRectInset, dy: borderRectInset)
        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
        context?.addPath(borderPath.cgPath)

        borderColor.setStroke()
        context?.strokePath()

        let edgeInset = cornerRadius
        let edgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        let image = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: edgeInsets)

        UIGraphicsEndImageContext()

        return image!
    }

    func tintedImage(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        color.set()

        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFillUsingBlendMode(rect, CGBlendMode.screen)
        draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: 1.0)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

}
