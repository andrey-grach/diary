import Foundation
import UIKit

final class AddTaskScreenAssembly: ScreenAssembly {
    static func assemble() -> UIViewController {
        let router = AddTaskScreenRouter()
        let service = DiaryService()
        let presenter = AddTaskScreenPresenter(
            router: router,
            service: service
        )
        let tableAdapter = AddTaskScreenTableAdapter()

        let view = AddTaskScreenViewController(
            presenter: presenter,
            tableAdapter: tableAdapter
        )
        
        presenter.view = view
        router.view = view
//        tableAdapter.presenter = presenter
        
        return view
    }
}
