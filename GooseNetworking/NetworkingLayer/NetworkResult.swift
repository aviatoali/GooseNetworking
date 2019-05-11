import Foundation
/**
 This enum is the representation of a Result for a Asynchronous function. It can represent either a succes with the type of an Error with the ErrorType
 - author: Ali H. Shah
 - date: 01/25/2019
 */
public enum NetworkResult<T, E: Error> {
    case success(T)
    case failure(E)
}

public class StatusCodeData {
    public let statusCode: Int
    public let data: Data
    
    public init(statusCode: Int, data: Data) {
        self.statusCode = statusCode
        self.data = data
    }
}
