import Foundation

final class TasksScreenPresenter {
    
    struct Constants {
        static let hoursInDay = 24
    }
    // MARK: - Properties
    weak var view: TasksScreenViewInput?
    
    // MARK: - Private Properties
    private let router: TasksScreenRouterProtocol
    private let service: DiaryServiceProtocol    
    private(set) var state: TasksScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    private var selectedDate: Date = Date()
    private var calendarManager = CalendarManager.shared
    private var selectedCollectionViewCell: IndexPath?
    
    init(router: TasksScreenRouterProtocol, service: DiaryServiceProtocol) {
        self.router = router
        self.service = service
    }
    
    private func getFormattedDateFor(date: Date, format: DateTimeFormat) -> String {
         DateHelper.getString(fromDate: date, format: format).capitalized
    }
    
    private func prepareDataForEventView(with data: TasksItem) -> EventViewData? {
        guard let dateStart = DateHelper.getDate(fromTimestamp: data.dateStart),
              let dateFinish = DateHelper.getDate(fromTimestamp: data.dateFinish) else { return nil }
        let timeStartString = DateHelper.getString(fromDate: dateStart, format: .hhmmColon)
        let timeFinishString = DateHelper.getString(fromDate: dateFinish, format: .hhmmColon)
        
        return .init(title: data.name, date: "\(timeStartString) - \(timeFinishString)")
    }
}

extension TasksScreenPresenter: TasksScreenPresenterProtocol {
    func eventBlockTapped(task: TasksItem) {
        router.routeToTaskDetails(task)
    }
    
    func viewDidAppear() {
        guard let selectedCollectionViewCell = selectedCollectionViewCell else { return }
        view?.collectionView.scrollToItem(
            at: selectedCollectionViewCell,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    func selectCurrentDay() {
        let calendar = Calendar.current
        let today = Date()
        
        view?.dateLabel.text = getFormattedDateFor(date: today, format: .EEEEColondMMMMyyyy)
        
        if let index = calendarManager.getDaysInCurrentMonth().firstIndex(where: { calendar.isDate($0.0, inSameDayAs: today) }) {
            selectedCollectionViewCell = IndexPath(item: index, section: 0)
            view?.collectionView.reloadData()
            view?.collectionView.layoutIfNeeded()
        }
    }
    
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
        selectCurrentDay()
    }
}

extension TasksScreenPresenter: TasksScreenTableAdapterOutput {
    func addEventView(taskItem: TasksItem?) {
        
        view?.addEvent(taskItem: taskItem)
    }
    
    func prepareTasksForSelectedDate(tasks: [TasksItem]) -> [TasksItem?] {
        let calendar = Calendar.current
        
        // Получаем начало и конец текущего дня
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Фильтруем задачи для текущего дня
        let todayTasks = tasks.filter { task in
            guard let taskDateStart = DateHelper.getDate(fromTimestamp: task.dateStart) else { return false }
            return taskDateStart >= startOfDay && taskDateStart < endOfDay
        }
        
        // Создаем массив с 24 элементами (по одному на каждый час)
        var hourlyTasks: [TasksItem?] = Array(repeating: nil, count: Constants.hoursInDay)
        
        // Группируем задачи по часам
        for task in todayTasks {
            guard let taskDateStart = DateHelper.getDate(fromTimestamp: task.dateStart) else { continue }
            let hour = calendar.component(.hour, from: taskDateStart)
            // Сохраняем задачу в соответствующий ей час.
            hourlyTasks[hour] = task
        }
        return hourlyTasks
    }
}

extension TasksScreenPresenter: TasksScreenCollectionAdapterOutput {
    func updateSelectedDate(date: Date, indexPath: IndexPath) {
        selectedDate = date
        selectedCollectionViewCell = indexPath
        view?.removeEventViews()
    }
    
    func getSelectedCollectionViewCell() -> IndexPath? {
        selectedCollectionViewCell
    }
    
    func updateDateLabelText(with text: String) {
        view?.dateLabel.text = text
    }
}
