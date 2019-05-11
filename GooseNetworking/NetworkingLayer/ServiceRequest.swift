import Foundation
import RxSwift
import RxCocoa
/**
 These are the objects that will allow the call to the different ApiService
 - author: Ali H. Shah
 - date: 01/25/2019
 */
public struct ServiceRequest {
    private let WRONG_HTTPRESPONSE = "Wrong HTTPResponse"
    private let srvProtocol: ServiceProtocol
    private let networkClient: NetworkClient

    public init(srvProtocol: ServiceProtocol) {
        self.srvProtocol = srvProtocol
        let url = self.srvProtocol.BaseUrl()
        let endPoint = self.srvProtocol.Url()

        self.networkClient = NetworkClient(
            serviceProtocol: self.srvProtocol.Protocol(),
            serviceMethod: self.srvProtocol.Method(),
            baseUrl: url,
            endPoint: endPoint,
            body: self.srvProtocol.Body(),
            headers: self.srvProtocol.Headers()
        )
    }

    public func NetworkRequest() -> Observable<NetworkResult<StatusCodeData, NetworkErrorType>> {
        return URLSession.shared.rx.response(request: self.networkClient.obtainNSURLRequest())
            .flatMap({ (response: URLResponse, data: Data) -> Observable<NetworkResult<StatusCodeData, NetworkErrorType>> in
                if let response = response as? HTTPURLResponse {
                    return self.srvProtocol.HandleResponse(statusCodeData: StatusCodeData(statusCode: response.statusCode, data: data))
                }
                return Observable.error(NetworkErrorType.InternalError(desc: self.WRONG_HTTPRESPONSE))
            })
    }
}
