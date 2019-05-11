import Foundation
import RxSwift
/**
 ViewModel for the networking layer test
 - author: Ali H. Shah
 - date: 02/07/2019
 */
class ViewModel {
    func GetPDFDoc() -> Observable<Document> {
        let srvReq = ServiceRequest(srvProtocol: LegalSrv())
        return srvReq.NetworkRequest().flatMap({ (data: ReqDataType) -> Observable<Document> in
            let legalError = NetworkErrorType.UnhandledError(desc: self.LEGAL_ERR_MSG )
            switch data {
            case .success(let statusCodeData):
                do {
                    self.document = try JSONDecoder().decode(Document.self, from: statusCodeData.data)
                    if self.document.url.isEmpty {
                        return Observable.error(legalError)
                    }
                    return Observable.just(self.document)
                } catch {
                    
                    return Observable.error(legalError)
                }
            case .failure:
                return Observable.error(legalError)
            }
        })
    }
}
