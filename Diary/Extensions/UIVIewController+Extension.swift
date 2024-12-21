import UIKit

private var activityIndicatorViewKey: UInt8 = 0

extension UIViewController {
    private struct AssociatedKeys {
        static var activityIndicatorView = "activityIndicatorView"
    }
    
    private var activityIndicatorView: ActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorViewKey) as? ActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &activityIndicatorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func presentActivityIndicator() {
        let nib = UINib(nibName: ActivityIndicatorView.identifier, bundle: nil)
        guard let customActivityIndicator = nib.instantiate(withOwner: self, options: nil).first as? ActivityIndicatorView else { return }
        
        self.activityIndicatorView = customActivityIndicator
        customActivityIndicator.activityIndicator.startAnimating()
        self.view.addSubview(customActivityIndicator)
    }
    
    func hideActivityIndicator() {
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
    }
}
