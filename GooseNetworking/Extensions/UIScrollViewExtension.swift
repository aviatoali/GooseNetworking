import UIKit
/**
 Custom extensions to UIScrollView
 - Author: Ali H. Shah
 - Date: 03/15/2019
 */
extension UIScrollView {
    var isAtTop: Bool {
        return self.contentOffset.y <= self.verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return self.contentOffset.y >= self.verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = self.contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = self.bounds.height
        let scrollContentSizeHeight = self.contentSize.height
        let bottomInset = self.contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
