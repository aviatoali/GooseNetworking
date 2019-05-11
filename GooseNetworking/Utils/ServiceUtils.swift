/**
 Utility functions for the services
 - author: Ali H. Shah
 - date: 03/25/2019
 */
import Foundation
import RxSwift

// Function to handle a generic error message from a service call
func HandleError(_ data: Data) -> String {
    do {
        let errorData = try JSONDecoder().decode(ErrorDataModel.self, from: data)
        if let message = errorData.error.message {
            return message
        }
        return "Unable to parse JSON"
    } catch {
        return "Unable to parse JSON"
    }
}
