import Foundation

protocol TaskDetailScreenViewInput: AnyObject {
    func handleState(_ state: TaskDetailScreenModels.State)
}

protocol TaskDetailScreenPresenterProtocol {
    func viewDidLoad()
}

final class TaskDetailScreenPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailScreenViewInput?
    private let router: TaskDetailScreenRouter
    private(set) var taskData: TasksItem
    private(set) var state: TaskDetailScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    
    init(router: TaskDetailScreenRouter, taskData: TasksItem) {
        self.router = router
        self.taskData = taskData
    }
}

extension TaskDetailScreenPresenter: TaskDetailScreenPresenterProtocol {
    func viewDidLoad() {
        state = .success(taskData)
    }
}

extension TaskDetailScreenPresenter: TaskDetailScreenTableAdapterOutput {
    
}
