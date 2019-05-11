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
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    private let labelBack = UILabel()
    private let viewPDF = PDFDocView()
    private let buttonShowPDF = ShadowButton(type: .system)
    private let SHOW_PDF_ACTION_TITLE = LocalString("show_pdf_action_title")
    private let BACK_ACTION_TITLE = LocalString("pdf_doc_view_back_action_title")
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private var viewModelSubscription: Disposable?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getPDFDoc()
    }
    
    private func setupViews() {
        view.backgroundColor = .lightGray
        contentView.backgroundColor = UIColor(red: 224/255, green: 228/255, blue: 240/255, alpha: 0.51)
        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true
        viewPDF.delegate = self
        labelBack.alpha = 0.0
        labelBack.text = BACK_ACTION_TITLE
        labelBack.textColor = UIColor.blue
        labelBack.isUserInteractionEnabled = true
        let tapReco = UITapGestureRecognizer(target: self, action: #selector(self.backTapped))
        labelBack.addGestureRecognizer(tapReco)
        buttonShowPDF.backgroundColor = UIColor.blue.withAlphaComponent(0.51)
        buttonShowPDF.setTitle(SHOW_PDF_ACTION_TITLE, for: .normal)
        buttonShowPDF.setTitleColor(UIColor(red: 82/255, green: 142/255, blue: 255/255, alpha: 1.0), for: .normal)
        buttonShowPDF.addTarget(self, action: #selector(self.showPDFTapped), for: .touchUpInside)
        buttonShowPDF.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buttonShowPDF.SetShadow(cornerRadius: 4, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).withAlphaComponent(0.18).cgColor, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 13, shadowOpacity: 1.0)
        activityIndicator.color = UIColor.blue
        layoutViews()
    }
    
    private func layoutViews() {
        view.addSubview(contentView)
        contentView.AddSubviews(buttonShowPDF, activityIndicator, labelBack)
        contentViewResize()
        activityIndicator.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(contentView)
            make.height.width.equalTo(100)
        }
        buttonShowPDF.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        labelBack.snp.makeConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(contentView.snp.left).offset(17)
            make.width.equalTo(100)
        }
    }
    
    private func contentViewResize(toFull: Bool = false, animated: Bool = false) {
        contentView.snp.remakeConstraints { make -> Void in
            make.center.equalTo(view)
            if (toFull) {
                make.height.equalTo(view.snp.height).offset(-50)
                addPDFView()
            } else {
                make.height.equalTo(100)
                removePDFView()
            }
            make.width.equalTo(view.snp.width).offset(-50)
        }
        if (animated) {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    private func addPDFView() {
        contentView.addSubview(viewPDF)
        viewPDF.snp.remakeConstraints { make -> Void in
            make.top.equalTo(contentView.snp.top).offset(50)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-17)
        }
        viewPDF.alpha = 1.0
        buttonShowPDF.alpha = 0.0
        labelBack.alpha = 1.0
    }
    
    private func removePDFView() {
        buttonShowPDF.alpha = 1.0
        labelBack.alpha = 0.0
        viewPDF.removeFromSuperview()
    }
    
    private func getPDFDoc() {
        activityIndicator.startAnimating()
        viewModelSubscription = viewModel.GetPDFDoc()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self ] (document: Document) -> Void in
                    if let myself = self {
                        myself.viewPDF.showPDF(document: document)
                        myself.activityIndicator.stopAnimating()
                    }
                }, onError: { [weak self] (error) -> Void in
                    if let myself = self {
                        myself.activityIndicator.stopAnimating()
                        myself.showErrorAlert(title: myself.viewModel.DOC_ERR_TITLE, message: myself.viewModel.DOC_ERR_MSG, actionTitle: myself.viewModel.DOC_ERR_ACTION_TITLE, onActionTap: { _ -> Void in
                            myself.getPDFDoc()
                        })
                    }
                }, onCompleted: {() -> Void in})
        self.viewModelSubscription?.disposed(by: self.disposeBag)
    }
    
    private func showErrorAlert(title: String?, message: String?, actionTitle: String, onActionTap: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.view.endEditing(true)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: onActionTap))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showPDFTapped() {
        contentViewResize(toFull: true, animated: true)
    }
    
    @objc func backTapped() {
        print("@@@@@@@@@@@ HAPPENING")
        contentViewResize(toFull: false, animated: true)
    }
}

extension ViewController: PDFDocDelegate {
    func showDocError() {
        self.activityIndicator.stopAnimating()
        self.showErrorAlert(title: self.viewModel.DOC_ERR_TITLE, message: self.viewModel.DOC_ERR_MSG, actionTitle: self.viewModel.DOC_ERR_ACTION_TITLE, onActionTap: { _ -> Void in
            self.getPDFDoc()
        })
    }
}
