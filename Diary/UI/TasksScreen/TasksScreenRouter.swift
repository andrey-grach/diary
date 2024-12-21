import UIKit

protocol TasksScreenRouterProtocol {
    func routeToTaskDetails(_ task: TasksItem)
}

final class TasksScreenRouter {
    weak var view: UIViewController?
}

extension TasksScreenRouter: TasksScreenRouterProtocol {
    func routeToTaskDetails(_ task: TasksItem) {
        let taskDetailController = TaskDetailScreenAssembly.assemble(taskData: task)
        view?.navigationController?.pushViewController(taskDetailController, animated: true)
    }
}
