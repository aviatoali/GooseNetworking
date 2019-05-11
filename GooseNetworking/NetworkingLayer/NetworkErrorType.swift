import Foundation
/**
 Enum that represents the different types of errors a network api call can have.
 - author: Ali H. Shah
 - date: 01/25/2019
 */
public enum NetworkErrorType: Error {
    case NotFoundError
    case InternalError(desc : String)
    case ConnectionError(desc : String)
    case NotAuthorizedError()
    case UnhandledError(desc : String)

    var description: String {
        switch self {
        case .ConnectionError(let desc):
            return "ConnectionError \(desc)"
        case .NotFoundError:
            return "Not Found"
        case .InternalError(let desc):
            return desc
        case .NotAuthorizedError:
            return "Not Authorized"
        case .UnhandledError(let desc):
            return desc
        }
    }
}
