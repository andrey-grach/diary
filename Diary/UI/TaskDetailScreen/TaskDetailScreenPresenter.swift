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
    
    private func prepareCellData(with taskData: TasksItem) -> TaskDetailTableViewCellData? {
        guard let dateStart = DateHelper.getDate(fromTimestamp: taskData.dateStart),
              let dateFinish = DateHelper.getDate(fromTimestamp: taskData.dateFinish) else { return nil }
        let timeStartString = DateHelper.getString(fromDate: dateStart, format: .hhmmColon)
        let timeFinishString = DateHelper.getString(fromDate: dateFinish, format: .hhmmColon)
        
        return .init(
            title: taskData.name,
            date: "\(timeStartString) - \(timeFinishString)",
            description: taskData.description
        )
    }
}

extension TaskDetailScreenPresenter: TaskDetailScreenPresenterProtocol {
    func viewDidLoad() {
        guard let preparedCellData = prepareCellData(with: taskData) else { return } 
        state = .success(preparedCellData)
    }
}

extension TaskDetailScreenPresenter: TaskDetailScreenTableAdapterOutput {
    
}
