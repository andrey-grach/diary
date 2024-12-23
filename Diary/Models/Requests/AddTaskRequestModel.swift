import Foundation

struct AddTaskRequestModel: Codable {
    
    let data: Data?
    
    struct Data: Codable {
        var title: String
        var description: String
        var time: String
    }
    
//    init() {}
}
