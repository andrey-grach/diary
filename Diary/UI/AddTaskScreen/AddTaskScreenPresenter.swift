import Foundation

final class AddTaskScreenPresenter {
    
    // MARK: - Properties
    
    weak var view: AddTaskScreenViewInput?
    
    // MARK: - Private Properties
    
    private let router: AddTaskScreenRouterProtocol
    private let service: DiaryServiceProtocol
    
    private(set) var state: AddTaskScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        router: AddTaskScreenRouterProtocol,
        service: DiaryServiceProtocol
    ) {
        self.router = router
        self.service = service
    }
}

extension AddTaskScreenPresenter: AddTaskScreenPresenterProtocol {
    func viewDidLoad() {
        state = .success
    }
}
