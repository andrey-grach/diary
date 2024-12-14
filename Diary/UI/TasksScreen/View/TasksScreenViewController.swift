import Foundation
import UIKit

protocol TasksScreenViewInput: AnyObject {
    func handleState(_ state: TasksScreenModels.State)
}

protocol TasksScreenPresenterProtocol {
    func viewDidLoad()
}

final class TasksScreenViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private let presenter: TasksScreenPresenterProtocol
    private let tableAdapter: TasksScreenTableAdapter
    private var tasks: [TasksItem] = []
    private var calendarManager = CalendarManager.shared
    private var days: [(Date, Int)] = []
    private var collectionCellWidth: CGFloat = 0
    private var itemSize: CGSize = .zero

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
        // Вычисляем ширину ячейки только один раз
        let totalWidth = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 9
        collectionCellWidth = totalWidth / numberOfItemsPerRow
        calculateItemSize()
    }
    
    // Метод для расчета размера ячейки
        private func calculateItemSize() {
            let width = collectionView.bounds.width // Ширина коллекции
            let padding: CGFloat = 6 * 2 // Отступы (с учетом межстрочного расстояния)
            let availableWidth = width - padding // Доступная ширина для ячеек

            let numberOfItemsPerRow: CGFloat = 7 // Количество ячеек в строке
            let itemWidth = availableWidth / numberOfItemsPerRow // Ширина каждой ячейки

            itemSize = CGSize(width: itemWidth, height: itemWidth) // Высота может быть равна ширине для квадратных ячеек
        }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Вычисляем ширину ячейки только один раз
        calculateItemSize()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // Обновление размера при изменении ориентации или изменении размера
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        calculateItemSize() // Пересчитываем размер при изменении размеров
//        collectionView.collectionViewLayout.invalidateLayout() // Обновляем макет коллекции
//    }
    
    private func prepareTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func prepareCollectionView() {
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
    }
    
    
    // TODO: Loading indicator
    private func startLoading() {
    }
    
    private func stopLoading() {
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
    
    func tasksForToday() -> [String?] {
        let calendar = Calendar.current
        let now = Date()
        
        // Получаем начало и конец текущего дня
        let startOfDay = calendar.startOfDay(for: now)
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
            // TODO: table view / collection view fill and reload.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Получаем задачи для сегодняшнего дня
        let hourlyTasks = tasksForToday()
        
        // Устанавливаем текст ячейки в зависимости от наличия задачи в этот час
        if let taskName = hourlyTasks[indexPath.row] {
            cell.textLabel?.text = taskName // Если задача есть, отображаем её
        } else {
            cell.textLabel?.text = "Нет задач" // Если задачи нет, отображаем это сообщение
        }
        
        return cell
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        cell.textLabel?.text = tasks[indexPath.row].name
        //        return cell
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
            reusableCell.configure(with: String(day))
        }
        return cell
    }
}

extension TasksScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension TasksScreenViewController: UICollectionViewDelegateFlowLayout {
    
    // Метод для задания минимального расстояния между строками
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 6
      }

      // Метод для задания минимального расстояния между ячейками
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 6
      }

      // Метод для задания размера ячейки
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return itemSize // Используем заранее рассчитанный размер
      }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let totalWidth = collectionView.bounds.width
////        let numberOfItemsPerRow: CGFloat = 8
////        let itemWidth = totalWidth / numberOfItemsPerRow
//        
//        return CGSize(width: collectionCellWidth, height: 60)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        0
//    }
}
