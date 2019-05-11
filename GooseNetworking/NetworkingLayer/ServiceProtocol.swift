import Foundation
import RxSwift
/**
 This protocol has to be implemented by the specific services used in the project.
 - author: Ali H. Shah
 - date: 01/25/2019
 */
public protocol ServiceProtocol {
    func Url() -> String?
    func Headers() -> [String: String]
    func Body() -> [String: Any]?
    func Protocol() -> HTTPProtocol
    func Method() -> HTTPMethod
    func BaseUrl() -> String?
    func HandleResponse(statusCodeData: StatusCodeData) -> Observable<NetworkResult<StatusCodeData, NetworkErrorType>>
}
