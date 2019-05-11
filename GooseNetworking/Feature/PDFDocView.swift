import Foundation
import PDFKit
import SnapKit
/**
 Custom UIView for displaying the pdf document
 - Author: Ali H. Shah
 - Date: 03/14/2019
 - Note:
 - Used in: ViewController
 */
class PDFDocView: UIView {
    private let viewPDFContainer: UIView = UIView()
    private let viewTopBlur: UIView = UIView()
    private let viewBottomBlur: UIView = UIView()
    private let viewPDF: PDFView = PDFView()
    private let HORIZONTAL_INSET: CGFloat = 34
    private let arrayCgColorsTop: [CGColor] = [UIColor.white.withAlphaComponent(0.8).cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
    weak var delegate: PDFDocDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        alpha = 0.0
        viewPDFContainer.backgroundColor = .white
        viewPDFContainer.layer.cornerRadius = 8.0
        viewPDFContainer.clipsToBounds = true
        viewTopBlur.alpha = 0.0
        viewTopBlur.isUserInteractionEnabled = false
        viewBottomBlur.alpha = 0.0
        viewBottomBlur.isUserInteractionEnabled = false
        layoutViews()
    }
    
    private func layoutViews() {
        addSubview(viewPDFContainer)
        viewPDFContainer.AddSubviews(viewPDF, viewTopBlur, viewBottomBlur)
        viewPDFContainer.snp.remakeConstraints { [weak self] make -> Void in
            if let myself = self {
                make.centerX.equalTo(myself.snp.centerX)
                make.width.equalTo(myself.snp.width).offset(-myself.HORIZONTAL_INSET)
                make.top.equalTo(myself.snp.top)
                make.bottom.equalTo(myself.snp.bottom).offset(-10)
            }
        }
        viewPDF.snp.remakeConstraints { [weak self] make -> Void in
            if let myself = self {
                make.edges.equalTo(myself.viewPDFContainer)
            }
        }
        viewTopBlur.snp.remakeConstraints { [weak self] make -> Void in
            if let myself = self {
                make.top.equalTo(myself.viewPDFContainer.snp.top)
                make.left.equalTo(myself.viewPDFContainer.snp.left)
                make.right.equalTo(myself.viewPDFContainer.snp.right)
                make.height.equalTo(myself.viewPDFContainer.snp.height).dividedBy(4)
            }
        }
        viewBottomBlur.snp.remakeConstraints { [weak self] make -> Void in
            if let myself = self {
                make.bottom.equalTo(myself.viewPDFContainer.snp.bottom).offset(-6)
                make.left.equalTo(myself.viewPDFContainer.snp.left)
                make.right.equalTo(myself.viewPDFContainer.snp.right)
                make.height.equalTo(myself.viewTopBlur.snp.height)
            }
        }
    }
    
    func showPDF(document: Document) {
        let urlStr = document.url
        if let url = URL(string: urlStr) {
            do {
                let data = try Data(contentsOf: url)
                let pdfDocument = PDFDocument(data: data)
                viewPDF.displayDirection = .vertical
                viewPDF.document = pdfDocument
                viewPDF.displaysPageBreaks = false
                viewPDF.displayMode = .singlePageContinuous
                if let docView = viewPDF.documentView {
                    let docWidth = docView.bounds.width
                    let pdfContainerWidth = viewPDFContainer.bounds.width
                    viewPDF.scaleFactor = pdfContainerWidth/docWidth
                }
                if let pdfScrollView: UIScrollView = viewPDF.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                    pdfScrollView.contentSize = CGSize(width: 0, height: pdfScrollView.contentSize.height)
                    pdfScrollView.alwaysBounceHorizontal = false
                    pdfScrollView.delegate = self
                }
                removeShadows(pdfView:viewPDF)
                viewTopBlur.layer.addSublayer(createBlurGradientLayer(frame:viewTopBlur.bounds, colors:arrayCgColorsTop))
                viewBottomBlur.layer.addSublayer(createBlurGradientLayer(frame:viewBottomBlur.bounds, colors:arrayCgColorsTop.reversed()))
            } catch {
                delegate?.showDocError()
            }
        }
    }
    
    private func createBlurGradientLayer(frame: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientMask: CAGradientLayer = CAGradientLayer()
        gradientMask.frame = frame
        gradientMask.colors = colors
        return gradientMask
    }
    
    // NOTE: The ability to remove shadows from PDFView is iOS 12 and up so I put this hack here to remove shadows manually
    private func removeShadows(pdfView: UIView) {
        pdfView.clipsToBounds = true
        if pdfView.subviews.isEmpty {
            return
        }
        for view in pdfView.subviews {
            removeShadows(pdfView: view)
        }
    }
}

extension PDFDocView: UIScrollViewDelegate {
    // NOTE: The manual shadow-removal hack above gets reversed on scroll when the pages are being redrawn so this is here to keep the shadows off
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        removeShadows(pdfView:viewPDF)
        if scrollView.isAtTop {
            viewTopBlur.alpha = 0.0
            viewBottomBlur.alpha = 1.0
        } else if scrollView.isAtBottom {
            viewTopBlur.alpha = 1.0
            viewBottomBlur.alpha = 0.0
        } else {
            viewTopBlur.alpha = 1.0
            viewBottomBlur.alpha = 1.0
        }
    }
}

protocol PDFDocDelegate: NSObjectProtocol {
    func showDocError()
}
