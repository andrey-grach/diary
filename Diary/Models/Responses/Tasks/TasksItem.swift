import Foundation

struct TasksItem: Codable {
    let id: Int
    let name: String
    let description: String
    let dateStart: Int
    let dateFinish: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case dateStart = "date_start"
        case dateFinish = "date_finish"
    }
}
