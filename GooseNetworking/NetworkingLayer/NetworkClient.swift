import Foundation
/**
 Network client to be used by the ServiceCaller.
 - author: Ali H. Shah
 - date: 01/25/2019
 */
struct NetworkClient {
    private let srvMethod: HTTPMethod
    private let srvProtocol: HTTPProtocol
    private let baseURL: String?
    private let endPoint: String?
    private let headers: [String: String]?
    private let body: [String: Any]?
    private let completeUrl: URL?
    
    init(serviceProtocol: HTTPProtocol, serviceMethod: HTTPMethod, baseUrl: String?, endPoint: String?, body: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.srvMethod = serviceMethod
        self.srvProtocol = serviceProtocol
        self.baseURL = baseUrl
        self.body = body
        self.headers = headers
        self.endPoint = endPoint
        if let url = self.baseURL, let ep = self.endPoint {
            self.completeUrl = URL(string: "\(self.srvProtocol.rawValue)://\(url)/\(ep)")
        } else {
            self.completeUrl = nil
        }
    }

    func obtainNSURLRequest() -> URLRequest {
        if let stringUrlRequest = self.completeUrl {
            var request = URLRequest(url: stringUrlRequest)
            if let headers = self.headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            request.httpMethod = self.srvMethod.rawValue
            if let body = self.body {
                do {
                    let data = try JSONSerialization.data(withJSONObject: body, options: [])
                    request.httpBody = data
                } catch {}
            }
            return request
        }
        if let bUrl = self.baseURL, let ep = self.endPoint {
            fatalError("Cannot convert string to URL -> \((self.srvProtocol))://\(bUrl)/\(ep))")
        }
        fatalError("Error when networking")
    }
}
