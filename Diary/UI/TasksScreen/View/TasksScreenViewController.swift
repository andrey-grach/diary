import Foundation
import UIKit

protocol TasksScreenViewInput: AnyObject {
    func handleState(_ state: TasksScreenModels.State)
}

protocol TasksScreenPresenterProtocol {
    func viewDidLoad()
}

final class TasksScreenViewController: UIViewController {
    
    struct Constants {
        static let tableViewCellHeight: CGFloat = 44.0
        static let secondsInOneHour = 3600
        static let minutsInOneHour = 60
        static let spaceForTimeLabel: CGFloat = 80.0
        static let hoursInDay = 24
        static let numberOfIndentsInCollectionView: CGFloat = 6
        static let indentWidth: CGFloat = 6.0
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!
    private var associatedKey: UInt8 = 0
    private let presenter: TasksScreenPresenterProtocol
    private let tableAdapter: TasksScreenTableAdapter
    private var tasks: [TasksItem] = []
    private var calendarManager = CalendarManager.shared
    private var days: [(Date, Int)] = []
    private var collectionCellWidth: CGFloat = 0
    private var collectionViewCellSize: CGSize = .zero
    private var selectedDate: Date = Date()
    private var selectedCollectionViewCell: IndexPath?
    private var eventViews: Set<EventView> = []

    init(presenter: TasksScreenPresenterProtocol, tableAdapter: TasksScreenTableAdapter) {
        self.presenter = presenter
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // TODO: Localizable
        title = "Список дел"
        presenter.viewDidLoad()
        prepareTableView()
        prepareCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        days = calendarManager.getDaysInCurrentMonth()
        selectCurrentDay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculateCollectionViewCellSize()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let selectedCollectionViewCell = selectedCollectionViewCell else { return }
        collectionView.scrollToItem(
            at: selectedCollectionViewCell,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    private func addEvent(taskItem: TasksItem?) {
        guard let taskItem = taskItem else { return }
        
        // Удаляем существующий eventView, если он есть
        removeExistingEventView(for: taskItem)
        
        // Создание нового eventView
        guard let eventView = EventView.loadFromNib() else { return }
        
        // Получаем дату начала и конца события
        guard let dateStart = Int(taskItem.dateStart), let dateFinish = Int(taskItem.dateFinish) else { return }
        
        // Вычисляем длительность в секундах
        let totalHeight = calculateEventViewHeight(dateStart: dateStart, dateFinish: dateFinish)
        
        // Получаем верхний отступ
        guard let topOffset = calculateEventViewTopOffset(from: taskItem.dateStart) else { return }

        // Настройка заголовка события
        configureEventView(eventView, with: taskItem)
        
        // Добавляем eventView как сабвью таблицы
        tableView.addSubview(eventView)
        
        NSLayoutConstraint.activate([
            eventView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: Constants.spaceForTimeLabel),
            eventView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            eventView.heightAnchor.constraint(equalToConstant: totalHeight),
            eventView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: topOffset)
        ])
        
        // Сохраняем ссылку на добавленный eventView
        eventViews.insert(eventView)
    }

    private func removeExistingEventView(for taskItem: TasksItem) {
        if let existingEventView = eventViews.first(where: {
            objc_getAssociatedObject($0, &associatedKey) as? TasksItem == taskItem
        }) {
            existingEventView.removeFromSuperview()
            eventViews.remove(existingEventView)
        }
    }

    private func calculateEventViewHeight(dateStart: Int, dateFinish: Int) -> CGFloat {
        let cellHeight: CGFloat = Constants.tableViewCellHeight
        let durationInSeconds = dateFinish - dateStart
        let durationInHours = durationInSeconds / Constants.secondsInOneHour
        let durationInMinutes = (durationInSeconds % Constants.secondsInOneHour) / Constants.minutsInOneHour
        let heightPerMinute: CGFloat = cellHeight / CGFloat(Constants.minutsInOneHour)
        
        return CGFloat(durationInHours) * cellHeight + CGFloat(durationInMinutes) * heightPerMinute
    }

    private func calculateEventViewTopOffset(from timestamp: String) -> CGFloat? {
        guard let date = DateHelper.getDate(fromTimestamp: timestamp) else { return nil }
        let calendarComponents: Set<Calendar.Component> = [.hour, .minute]
        let dateComponents = calendarManager.getDateComponentsFor(calendarComponents: calendarComponents, date: date)
        guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return nil }
        let totalMinutes = hour * Constants.minutsInOneHour + minute
        return CGFloat(totalMinutes) * Constants.tableViewCellHeight / CGFloat(Constants.minutsInOneHour)
    }

    private func configureEventView(_ eventView: EventView, with taskItem: TasksItem) {
        eventView.configure(timeStart: taskItem.dateStart, timeFinish: taskItem.dateFinish, title: taskItem.name)
        eventView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTapped(_:)))
        eventView.addGestureRecognizer(tapGesture)

        objc_setAssociatedObject(eventView, &associatedKey, taskItem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func eventTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedEventView = sender.view as? EventView,
              let taskItem = objc_getAssociatedObject(tappedEventView, &associatedKey) as? TasksItem else { return }

        print("Задача нажата: \(taskItem.name)")
        
        //TODO: Переход на экран детальки задачи
//        navigateToTaskDetail(taskItem: taskItem)
    }
    
    // Метод для расчета размера ячейки
    private func calculateCollectionViewCellSize() {
        let width = collectionView.bounds.width
        let padding: CGFloat = Constants.numberOfIndentsInCollectionView * Constants.indentWidth // Отступы (с учетом межстрочного расстояния)
        let availableWidth = width - padding // Доступная ширина для ячеек
        
        let numberOfItemsPerRow: CGFloat = 7 // Количество ячеек в строке
        let itemWidth = availableWidth / numberOfItemsPerRow // Ширина каждой ячейки
        
        collectionViewCellSize = CGSize(width: itemWidth, height: itemWidth) // Высота может быть равна ширине для квадратных ячеек
    }
    
    private func prepareTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    private func prepareCollectionView() {
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
    }
    
    // TODO: Loading indicator
    private func startLoading() {
    }
    
    private func stopLoading() {
        print("Stop")
    }
    
    // TODO: Error alert
    private func showErrorAlert() {
    }
    
    func prepareTasksFor(date: Date) -> [TasksItem?] {
        let calendar = Calendar.current
        //        let now = date
        
        // Получаем начало и конец текущего дня
        let startOfDay = calendar.startOfDay(for: date)
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
            hourlyTasks[hour] = task // Сохраняем задачу в соответствующий ей час.
        }
        
        return hourlyTasks
    }
    
    private func getFormattedDateFor(date: Date, format: DateTimeFormat) -> String {
         DateHelper.getString(fromDate: date, format: format).capitalized
    }
    
    func selectCurrentDay() {
        let calendar = Calendar.current
        let today = Date()
        
        dateLabel.text = getFormattedDateFor(date: today, format: .EEEEColondMMMMyyyy)
        
        if let index = days.firstIndex(where: { calendar.isDate($0.0, inSameDayAs: today) }) {
            selectedCollectionViewCell = IndexPath(item: index, section: 0)
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(
                at: IndexPath(item: index, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
}

// MARK: - TasksScreenViewInput

extension TasksScreenViewController: TasksScreenViewInput {
    func handleState(_ state: TasksScreenModels.State) {
        switch state {
        case .loading:
            startLoading()
        case .success(let tasksResponse):
            stopLoading()
            self.tasks = tasksResponse.tasks
            tableView.reloadData()
        case .failure(let error):
            stopLoading()
            showErrorAlert()
        default:
            stopLoading()
        }
    }
}

extension TasksScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.hoursInDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hourlyTasks = prepareTasksFor(date: selectedDate)
        
        // Устанавливаем текст ячейки в зависимости от наличия задачи в этот час
        let hour = indexPath.row // Час, соответствующий текущему индексу
        let timeInterval = String(format: "%02d:00", hour) // Форматируем временной интервал
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
        
        if let reusableCell = cell as? TaskTableViewCell {
            if let task = hourlyTasks[hour] {
                reusableCell.configureCellWith(time: timeInterval)
                addEvent(taskItem: tasks.first(where: { $0.id == task.id }))
            } else {
                reusableCell.configureCellWith(time: timeInterval) // Отображаем временной интервал
            }
        }
        return cell
    }
}

extension TasksScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TasksScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath)
        let dayTuple = days[indexPath.item]
        let date = dayTuple.0
        let day = dayTuple.1
        
        if let reusableCell = cell as? MyCollectionViewCell {
            let weekdayString = getFormattedDateFor(date: date, format: .EEE)
            reusableCell.configureWith(dayNumber: String(day), dayTitle: weekdayString)
            if indexPath == selectedCollectionViewCell {
                reusableCell.setSelected()
                dateLabel.text = getFormattedDateFor(date: date, format: .EEEEColondMMMMyyyy)
            }
        }
        return cell
    }
}

extension TasksScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedDate = days[indexPath.item].0
        selectedCollectionViewCell = indexPath
        for eventView in eventViews {
            eventView.removeFromSuperview()
        }
        eventViews.removeAll()
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension TasksScreenViewController: UICollectionViewDelegateFlowLayout {
    
    // Метод для задания минимального расстояния между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.indentWidth
    }
    
    // Метод для задания минимального расстояния между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    // Метод для задания размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionViewCellSize
    }
}
