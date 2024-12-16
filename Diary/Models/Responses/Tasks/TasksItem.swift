import Foundation

struct TasksItem: Codable, Equatable {
    let id: Int
    let name: String
    let description: String
    let dateStart: String
    let dateFinish: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case dateStart = "date_start"
        case dateFinish = "date_finish"
    }
}
