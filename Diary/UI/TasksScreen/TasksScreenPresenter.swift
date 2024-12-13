import Foundation

final class TasksScreenPresenter {
    
    // MARK: - Properties
    weak var view: TasksScreenViewInput?
    private let router: TasksScreenRouterProtocol
    private let service: DiaryServiceProtocol
    
    private(set) var tasks: TasksResponse?
    
    private(set) var state: TasksScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    
    init(router: TasksScreenRouterProtocol, service: DiaryServiceProtocol) {
        self.router = router
        self.service = service
    }
}

extension TasksScreenPresenter: TasksScreenPresenterProtocol {
    func viewDidLoad() {
        service.getTasks(
            completion: { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let responseData):
                    tasks = responseData
                case .failure(let error):
                    print("Ошибка в методе getTasks: \(error)")
                    // TODO: tasks = mockDataManager.getTasks()
                }
            }
        )
    }
}
