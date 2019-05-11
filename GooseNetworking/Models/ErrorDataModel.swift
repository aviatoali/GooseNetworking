import Foundation
/**
 DataModel to be use to decode the errors from service calls
 - author: Ali H. Shah
 - date: 03/25/2019
 */
struct ErrorDataModel: Decodable {
    let error: ErrorInformationDataModel
}

struct ErrorInformationDataModel: Decodable {
    let code: Int?
    let message: String?
}
