import RxSwift
/**
 Implementation of the ServiceProtocol to allow calls to the PDFDoc service
 - Author: Ali H. Shah
 - Date: 02/13/2019
 - Note:
 - Used in: ViewModel
 */
class PDFDocSrv: ServiceProtocol {
    init() {}
    
    func Url() -> String? {
        return "legal"
    }
    
    func Headers() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    func Body() -> [String: Any]? {
        return nil
    }
    
    func Protocol() -> HTTPProtocol {
        return HTTPProtocol.Https
    }
    
    func Method() -> HTTPMethod {
        return HTTPMethod.GET
    }
    
    func BaseUrl() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: ApiUrlCode.MOBILE_PLATFORM) as? String
    }
    
    func HandleResponse(statusCodeData: StatusCodeData) -> Observable<NetworkResult<StatusCodeData, NetworkErrorType>> {
        return Observable.just(NetworkResult.success(statusCodeData))
    }
}
