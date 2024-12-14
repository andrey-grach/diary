import Foundation

final class TasksScreenPresenter {
    
    // MARK: - Properties
    weak var view: TasksScreenViewInput?
    
    //MARK: - Private Properties
    private let router: TasksScreenRouterProtocol
    private let service: DiaryServiceProtocol
    
//    private(set) var tasks: TasksResponse?
    
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
        state = .loading
        service.getTasks(
            completion: { [weak self] response in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch response {
                    case .success(let responseData):
                        self.state = .success(responseData)
                    case .failure(let error):
                        print("Ошибка в методе getTasks: \(error)")
                        self.state = .failure(error)
                        // TODO: tasks = mockDataManager.getTasks()
                    }
                }
            }
        )
    }
}
