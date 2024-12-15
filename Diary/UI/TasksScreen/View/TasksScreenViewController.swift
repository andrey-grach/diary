import Foundation
import UIKit

protocol TasksScreenViewInput: AnyObject {
    func handleState(_ state: TasksScreenModels.State)
}

protocol TasksScreenPresenterProtocol {
    func viewDidLoad()
}

final class TasksScreenViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!

    
    private let presenter: TasksScreenPresenterProtocol
    private let tableAdapter: TasksScreenTableAdapter
    private var tasks: [TasksItem] = []
    private var calendarManager = CalendarManager.shared
    private var days: [(Date, Int)] = []
    private var collectionCellWidth: CGFloat = 0
    private var collectionViewCellSize: CGSize = .zero
    private var selectedDate: Date = Date()
    private var selectedCollectionViewCell: IndexPath?
    
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
        
//        eventView.configureView(title: "zxc")
        
        // Вычисляем ширину ячейки только один раз
        //        let totalWidth = collectionView.bounds.width
        //        let numberOfItemsPerRow: CGFloat = 9
        //        collectionCellWidth = totalWidth / numberOfItemsPerRow
        //        calculateCollectionViewCellSize()
    }
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //
    //        // Вычисляем ширину ячейки только один раз
    //        calculateCollectionViewCellSize()
    //        collectionView.collectionViewLayout.invalidateLayout()
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculateCollectionViewCellSize()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: self.selectedCollectionViewCell!, at: .centeredHorizontally, animated: true)
    }
    
    // Метод для расчета размера ячейки
    private func calculateCollectionViewCellSize() {
        let width = collectionView.bounds.width
        let padding: CGFloat = 6 * 6 // Отступы (с учетом межстрочного расстояния)
        let availableWidth = width - padding // Доступная ширина для ячеек
        
        let numberOfItemsPerRow: CGFloat = 7 // Количество ячеек в строке
        let itemWidth = availableWidth / numberOfItemsPerRow // Ширина каждой ячейки
        
        collectionViewCellSize = CGSize(width: itemWidth, height: itemWidth) // Высота может быть равна ширине для квадратных ячеек
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        collectionView.scrollToItem(at: self.selectedCollectionViewCell!, at: .centeredHorizontally, animated: true)
    //    }
    // Обновление размера при изменении ориентации или изменении размера
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        calculateItemSize() // Пересчитываем размер при изменении размеров
    //        collectionView.collectionViewLayout.invalidateLayout() // Обновляем макет коллекции
    //    }
    
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
    
    //    func filterTasks(for date: Date) {
    //        // Преобразуйте дату в нужный формат (например, timestamp)
    //        let calendar = Calendar.current
    //        let startOfDay = calendar.startOfDay(for: date)
    //
    //        // Фильтрация задач по дате
    //        let filteredTasks = tasks.filter { task in
    //            // Предполагается, что task имеет свойство timestamp
    //            return task.timestamp >= startOfDay.timeIntervalSince1970 && task.timestamp < startOfDay.addingTimeInterval(86400).timeIntervalSince1970
    //        }
    //    }
    
    // Функция для преобразования строки даты в объект Date
    //    func dateFromString(_ dateString: String) -> Date? {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Пример формата даты
    //        return dateFormatter.date(from: dateString)
    //    }
    
    func dateFromTimestamp(_ timestamp: String) -> Date? {
        guard let timeInterval = TimeInterval(timestamp) else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    //    func tasksForToday() -> [String?] {
    //        let calendar = Calendar.current
    //        let now = Date()
    //
    //        // Получаем начало и конец текущего дня
    //        let startOfDay = calendar.startOfDay(for: now)
    //        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    //
    //        // Фильтруем задачи для текущего дня
    //        let todayTasks = tasks.filter { task in
    //            guard let taskDateStart = dateFromString(task.dateStart) else { return false }
    //            return taskDateStart >= startOfDay && taskDateStart < endOfDay
    //        }
    //
    //        // Создаем массив с 24 элементами (по одному на каждый час)
    //        var hourlyTasks: [String?] = Array(repeating: nil, count: 24)
    //
    //        // Группируем задачи по часам
    //        for task in todayTasks {
    //            guard let taskDateStart = dateFromString(task.dateStart) else { continue }
    //            let hour = calendar.component(.hour, from: taskDateStart)
    //            hourlyTasks[hour] = task.name // Сохраняем имя задачи в соответствующий час
    //        }
    //
    //        return hourlyTasks
    //    }
    
    func prepareTasksFor(date: Date) -> [String?] {
        let calendar = Calendar.current
        //        let now = date
        
        // Получаем начало и конец текущего дня
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Фильтруем задачи для текущего дня
        let todayTasks = tasks.filter { task in
            guard let taskDateStart = dateFromTimestamp(task.dateStart) else { return false }
            return taskDateStart >= startOfDay && taskDateStart < endOfDay
        }
        
        // Создаем массив с 24 элементами (по одному на каждый час)
        var hourlyTasks: [String?] = Array(repeating: nil, count: 24)
        
        // Группируем задачи по часам
        for task in todayTasks {
            guard let taskDateStart = dateFromTimestamp(task.dateStart) else { continue }
            let hour = calendar.component(.hour, from: taskDateStart)
            hourlyTasks[hour] = task.name // Сохраняем имя задачи в соответствующий час
        }
        
        return hourlyTasks
    }
    
    private func getFormattedDateFor(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU") // Устанавливаем локаль для русского языка
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy 'года'" // Указываем формат даты
        
        let formattedDate = dateFormatter.string(from: date)
        dateLabel.text = formattedDate
    }
    
    func selectCurrentDay() {
        let calendar = Calendar.current
        let today = Date()
        
        getFormattedDateFor(date: today)
        // Находим индекс текущего дня в массиве
        if let index = days.firstIndex(where: { calendar.isDate($0.0, inSameDayAs: today) }) {
            selectedCollectionViewCell = IndexPath(item: index, section: 0)
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: self.selectedCollectionViewCell!, at: .centeredHorizontally, animated: true)
            //            DispatchQueue.main.async {
            //                self.collectionView.reloadData()
            //                self.collectionView.scrollToItem(at: self.selectedCollectionViewCell!, at: .centeredVertically, animated: true)
            //                self.collectionView.reloadData()
            //            }
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
        24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hourlyTasks = prepareTasksFor(date: selectedDate)
        
        // Устанавливаем текст ячейки в зависимости от наличия задачи в этот час
        let hour = indexPath.row // Час, соответствующий текущему индексу
        let timeInterval = String(format: "%02d:00 - %02d:00", hour, hour + 1) // Форматируем временной интервал
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
        
        if let reusableCell = cell as? TaskTableViewCell {
            if let taskName = hourlyTasks[hour] {
                reusableCell.configureCellWith(taskTitle: taskName, time: timeInterval)
            } else {
                reusableCell.configureCellWith(taskTitle: "Нет задач", time: timeInterval) // Отображаем временной интервал
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
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "EEE"
            let weekdayString = dateFormatter.string(from: date)
            
            reusableCell.configureWith(dayNumber: String(day), dayTitle: weekdayString)
            
            if indexPath == selectedCollectionViewCell {
                reusableCell.setSelected(true)
                getFormattedDateFor(date: date)
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
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension TasksScreenViewController: UICollectionViewDelegateFlowLayout {
    
    // Метод для задания минимального расстояния между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    // Метод для задания минимального расстояния между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Метод для задания размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }
}
