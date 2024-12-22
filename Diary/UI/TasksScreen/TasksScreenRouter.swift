import UIKit

protocol TasksScreenRouterProtocol {
    func routeToTaskDetails(_ task: TasksItem)
    func routeToAddTask()
}

final class TasksScreenRouter {
    weak var view: UIViewController?
}

extension TasksScreenRouter: TasksScreenRouterProtocol {
    func routeToTaskDetails(_ task: TasksItem) {
        let taskDetailController = TaskDetailScreenAssembly.assemble(taskData: task)
        view?.navigationController?.pushViewController(taskDetailController, animated: true)
    }
    
    func routeToAddTask() {
        let addTaskController = AddTaskScreenAssembly.assemble()
        view?.navigationController?.pushViewController(addTaskController, animated: true)
    }
}
