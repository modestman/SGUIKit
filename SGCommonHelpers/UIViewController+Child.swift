import UIKit

public extension UIViewController {
    
    func addChild(_ childController: UIViewController, with guide: LayoutGuide) {
        addChild(childController)
        view.addSubview(childController.view, with: guide)
        childController.didMove(toParent: self)
    }
    
    func addChild(_ childController: UIViewController, activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        addChild(childController)
        
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childController.view)
        NSLayoutConstraint.activate(constraints())
        
        childController.didMove(toParent: self)
    }
    
    func addChild(_ childController: UIViewController, into view: UIView? = nil) {
        addChild(childController)
        let containerView = view ?? self.view!
        containerView.addSubview(childController.view, with: containerView)
        childController.didMove(toParent: self)
    }
    
    func removeChild(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
    
}
