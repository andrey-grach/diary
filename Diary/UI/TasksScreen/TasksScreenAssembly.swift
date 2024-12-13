import UIKit

protocol ScreenAssembly {
    static func assemble() -> UIViewController
}

final class TasksScreenAssembly: ScreenAssembly {
    static func assemble() -> UIViewController {
        let router = TasksScreenRouter()
        let service = DiaryService()
        let presenter = TasksScreenPresenter(router: router, service: service)
        let tableAdapter = TasksScreenTableAdapter()
        let view = TasksScreenViewController(presenter: presenter, tableAdapter: tableAdapter)
        presenter.view = view
        
        return view
    }
}
