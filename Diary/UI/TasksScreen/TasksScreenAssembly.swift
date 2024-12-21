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
        let collectionAdapter = TasksScreenCollectionAdapter()
        let view = TasksScreenViewController(
            presenter: presenter,
            tableAdapter: tableAdapter,
            collectionAdapter: collectionAdapter
        )
        
        presenter.view = view
        router.view = view
        tableAdapter.presenter = presenter
        collectionAdapter.presenter = presenter
        
        return view
    }
}
