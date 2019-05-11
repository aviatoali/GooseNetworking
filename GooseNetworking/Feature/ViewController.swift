import Foundation
import SnapKit
import RxSwift
import RxCocoa
/**
 ViewController to server as sample for RxSwift-based Networking Layer concept
 - Author: Ali H. Shah
 - Date: 03/10/2019
 - Note:
 - ViewModel: ViewModel
 */
class ViewController: UIViewController {
    private let contentView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        contentView.backgroundColor = .cyan
        
        view.addSubview(contentView)
        

    }


}

