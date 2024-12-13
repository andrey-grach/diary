import Foundation

struct TasksResponse: Codable {
    let tasks: [TasksItem]
    
    init(tasks: [TasksItem]) {
        self.tasks = tasks
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let tasks = try container.decode(LossyCodableList<TasksItem>.self, forKey: .tasks)
            self.tasks = tasks.elements
        } catch {
            self.tasks = []
        }
    }
}
