import UIKit
/**
 Public extension for the UIView class to allow sharing behaviour across the project
 - author: Ali H. Shah
 - date: 02/07/2019
 */
public extension UIView {
    func AddSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
