import UIKit
/**
 Custom UIButton that has a drop shadow that decreases when button pressed down
 - Author: Ali H. Shah
 - Date: 03/03/2019
 */
class ShadowButton: UIButton {
    private var shadowOffset: CGSize = CGSize.zero
    private var shadowRadius: CGFloat = 0.0
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = self.isHighlighted
            if isHighlighted {
                animateActionPressBegan()
            } else {
                animateActionPressEnded()
            }
        }
    }
    
    func SetShadow(cornerRadius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
        layer.borderColor = shadowColor
        layer.borderWidth = 0.5
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
    
    private func animateActionPressBegan() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            self?.layer.shadowOffset = CGSize.zero
            self?.layer.shadowRadius = 0
        })
    }
    
    private func animateActionPressEnded() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
            if let myself = self {
                myself.layer.shadowOffset = myself.shadowOffset
                myself.layer.shadowRadius = myself.shadowRadius
            }
        })
    }
}
