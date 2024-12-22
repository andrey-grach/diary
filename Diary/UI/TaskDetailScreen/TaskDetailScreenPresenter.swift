import Foundation

// MARK: - TaskDetailScreenViewInput

protocol TaskDetailScreenViewInput: AnyObject {
    func handleState(_ state: TaskDetailScreenModels.State)
}

// MARK: - TaskDetailScreenPresenterProtocol

protocol TaskDetailScreenPresenterProtocol {
    func viewDidLoad()
}

// MARK: - TaskDetailScreenPresenter

final class TaskDetailScreenPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailScreenViewInput?
    private(set) var taskData: TasksItem
    
    private(set) var state: TaskDetailScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    
    // MARK: - Lifecycle
    
    init(taskData: TasksItem) {
        self.taskData = taskData
    }
    
    // MARK: - Private Methods
    
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

// MARK: - TaskDetailScreenPresenterProtocol

extension TaskDetailScreenPresenter: TaskDetailScreenPresenterProtocol {
    func viewDidLoad() {
        guard let preparedCellData = prepareCellData(with: taskData) else { return }
        state = .success(preparedCellData)
    }
}
