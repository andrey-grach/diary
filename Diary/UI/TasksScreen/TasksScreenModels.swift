import Foundation

enum TasksScreenModels {
    enum State {
        case `default`
        case loading
        case success
        case failure(Error)
    }
}
