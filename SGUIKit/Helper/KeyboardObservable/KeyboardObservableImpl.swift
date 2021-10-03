import Combine
import UIKit

public final class KeyboardObservableImpl: NSObject, KeyboardObservable {
    
    // MARK: - Private properties
    
    private weak var presenter: UIView?
    
    private var cancellable: AnyCancellable?
    
    private var keyboardUpdate: AnyPublisher<KeyboardUpdate, Never> {
        let notificationCenter = NotificationCenter.default
        
        let keyboardWillHide = notificationCenter
            .publisher(for: UIResponder.keyboardWillHideNotification)
        
        let keyboardWillUpdateFrame = notificationCenter
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        
        return Publishers.MergeMany([keyboardWillHide, keyboardWillUpdateFrame])
            .compactMap { KeyboardUpdate(notification: $0) }
            .eraseToAnyPublisher()
    }
    
    public private(set) var closeKeyboardGesture: UITapGestureRecognizer?
    private var ignoredByCloseGesture: [UIView] = []
    
    // MARK: - Init
    
    public init(presenter: UIViewController) {
        self.presenter = presenter.view
    }
    
    public init(presenter: UIView) {
        self.presenter = presenter
    }
    
    // MARK: - Public methods
    
    public func bindKeyboardFrame(to constraint: NSLayoutConstraint) {
        bindKeyboardFrame(to: constraint, margin: { 0 })
    }
    
    public func bindKeyboardFrame(to constraint: NSLayoutConstraint, margin: @escaping () -> CGFloat) {
        cancellable = keyboardUpdate
            .sink { [weak self] keyboardUpdate in
                if keyboardUpdate.isOpeningKeyboard {
                    constraint.constant = keyboardUpdate.padding + margin()
                } else {
                    constraint.constant = keyboardUpdate.padding
                }
                
                self?.animateChanges(with: keyboardUpdate)
            }
    }
    
    public func bindKeyboardFrame(animated: Bool, to action: @escaping KeyboardUpdateClosure) {
        cancellable = keyboardUpdate
            .sink { [weak self] keyboardUpdate in
                action(keyboardUpdate)
                guard animated else { return }
                self?.animateChanges(with: keyboardUpdate)
            }
    }

    public func bindKeyboardFrame(to scrollView: UIScrollView, margin: @escaping () -> CGFloat) {
        cancellable = keyboardUpdate
            .sink { keyboardUpdate in
                var contentInset = scrollView.contentInset
                var scrollInset = scrollView.verticalScrollIndicatorInsets
                contentInset.bottom = keyboardUpdate.padding + margin()
                scrollInset.bottom = keyboardUpdate.padding + margin()
                
                scrollView.contentInset = contentInset
                scrollView.verticalScrollIndicatorInsets = scrollInset
            }
    }
    
    public func unbindKeyboardFrame() {
        cancellable?.cancel()
        closeKeyboardGesture.map { presenter?.removeGestureRecognizer($0) }
    }
    
    public func setupCloseKeyboardGesture(view: UIView?, ignores subviews: [UIView]? = nil) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        (view ?? presenter)?.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
        
        closeKeyboardGesture = gestureRecognizer
        
        ignoredByCloseGesture = subviews ?? []
        gestureRecognizer.delegate = self
    }
    
    // MARK: - Private methods
    
    @objc private func dismissKeyboard() {
        presenter?.endEditing(true)
    }
    
    private func animateChanges(with keyboardUpdate: KeyboardUpdate) {
        UIView.animate(
            withDuration: keyboardUpdate.duration,
            delay: 0.0,
            options: keyboardUpdate.options,
            animations: { self.presenter?.layoutIfNeeded() },
            completion: nil
        )
    }
}

// MARK: - UIGestureRecognizerDelegate

extension KeyboardObservableImpl: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !ignoredByCloseGesture.contains(where: { touch.view?.isDescendant(of: $0) ?? false })
    }
}
