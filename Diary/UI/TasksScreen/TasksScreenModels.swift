import Foundation

enum TasksScreenModels {
    enum State {
        case `default`
        case loading
        case success(TasksResponse)
        case failure(Error)
    }
}
