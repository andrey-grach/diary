import UIKit

protocol TaskDetailScreenAssemblyProtocol {
    static func assemble(taskData: TasksItem) -> UIViewController
}

final class TaskDetailScreenAssembly: TaskDetailScreenAssemblyProtocol {
    static func assemble(taskData: TasksItem) -> UIViewController {
        let router = TaskDetailScreenRouter()
        let presenter = TaskDetailScreenPresenter(router: router, taskData: taskData)
        let tableAdapter = TaskDetailScreenTableAdapter()
        let view = TaskDetailScreenViewController(
            presenter: presenter,
            tableAdapter: tableAdapter
        )
        presenter.view = view
        tableAdapter.presenter = presenter
        
        return view
    }
}
