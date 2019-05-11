import Foundation
import RxSwift
/**
 ViewModel for the networking layer test
 - author: Ali H. Shah
 - date: 02/07/2019
 */
class ViewModel {
    private var document: Document = Document(url: "")
    let DOC_TITLE = LocalString("pdf_doc_view_title")
    let DOC_ERR_TITLE = LocalString("doc_get_err_title")
    let DOC_ERR_MSG = LocalString("doc_get_err_msg")
    let DOC_ERR_ACTION_TITLE = LocalString("doc_get_err_action_title")
    let SHOW_DOC_ACTION_TITLE = LocalString("show_pdf_action_title")
    
    func GetPDFDoc() -> Observable<Document> {
        let srvReq = ServiceRequest(srvProtocol: PDFDocSrv())
        return srvReq.NetworkRequest().flatMap({ (data: NetworkResult<StatusCodeData, NetworkErrorType>) -> Observable<Document> in
            let pdfDocError = NetworkErrorType.UnhandledError(desc: self.DOC_ERR_MSG )
            switch data {
            case .success(let statusCodeData):
                do {
                    self.document = try JSONDecoder().decode(Document.self, from: statusCodeData.data)
                    if self.document.url.isEmpty {
                        return Observable.error(pdfDocError)
                    }
                    return Observable.just(self.document)
                } catch {
                    return Observable.error(pdfDocError)
                }
            case .failure:
                return Observable.error(pdfDocError)
            }
        })
    }
}
