/**
 Decodable struct modeling the return from the get pdf document service
 - Author: Ali H. Shah
 - Date: 03/15/2019
 - Note:
 - Used in: ViewModel
 */
struct Document: Decodable {
    let url: String
    init(url: String) { self.url = url }
}
