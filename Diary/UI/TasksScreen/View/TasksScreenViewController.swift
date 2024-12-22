import Foundation
import UIKit

protocol TasksScreenViewInput: AnyObject {
    var collectionView: UICollectionView! { get }
    var dateLabel: UILabel! { get }
    func handleState(_ state: TasksScreenModels.State)
    func addEvent(taskItem: TasksItem?)
    func removeEventViews()
}

protocol TasksScreenPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func eventBlockTapped(task: TasksItem)
    func addTaskButtonTapped()
}

final class TasksScreenViewController: UIViewController {
    
    struct Constants {
        static let tableViewCellHeight: CGFloat = 44.0
        static let secondsInOneHour = 3600
        static let minutsInOneHour = 60
        static let spaceForTimeLabel: CGFloat = 80.0
        static let numberOfIndentsInCollectionView: CGFloat = 6
        static let indentWidth: CGFloat = 6.0
        static let numberOfDaysInWeek: CGFloat = 7
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    
    private var associatedKey: UInt8 = 0
    private let presenter: TasksScreenPresenterProtocol
    private let tableAdapter: TasksScreenTableAdapter
    private let collectionAdapter: TasksScreenCollectionAdapter
    private var calendarManager = CalendarManager.shared
    private var collectionCellWidth: CGFloat = 0
    private var collectionViewCellSize: CGSize = .zero
    
    private var selectedCollectionViewCell: IndexPath?
    private var eventViews: Set<EventView> = []
    
    init(
        presenter: TasksScreenPresenterProtocol,
        tableAdapter: TasksScreenTableAdapter,
        collectionAdapter: TasksScreenCollectionAdapter
    ) {
        self.presenter = presenter
        self.tableAdapter = tableAdapter
        self.collectionAdapter = collectionAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TasksScreen.Title".localized
        presenter.viewDidLoad()
        prepareTableView()
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateCollectionViewCellSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
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
        guard let prepareEventViewData = prepareDateForEventView(using: taskItem) else { return }
        eventView.configure(with: prepareEventViewData)
        eventView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTapped(_:)))
        eventView.addGestureRecognizer(tapGesture)

        objc_setAssociatedObject(eventView, &associatedKey, taskItem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func prepareDateForEventView(using taskItem: TasksItem) -> EventViewData? {
        guard let dateStart = DateHelper.getDate(fromTimestamp: taskItem.dateStart),
              let dateFinish = DateHelper.getDate(fromTimestamp: taskItem.dateFinish) else { return nil }
        let timeStartString = DateHelper.getString(fromDate: dateStart, format: .hhmmColon)
        let timeFinishString = DateHelper.getString(fromDate: dateFinish, format: .hhmmColon)
        
        return .init(title: taskItem.name, date: "\(timeStartString) - \(timeFinishString)")
    }
    
    @objc private func eventTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedEventView = sender.view as? EventView,
              let taskItem = objc_getAssociatedObject(tappedEventView, &associatedKey) as? TasksItem else { return }
        presenter.eventBlockTapped(task: taskItem)
    }
    
    private func calculateCollectionViewCellSize() {
        let width = collectionView.bounds.width
        let padding: CGFloat = Constants.numberOfIndentsInCollectionView * Constants.indentWidth // Отступы (с учетом межстрочного расстояния)
        let availableWidth = width - padding // Доступная ширина для ячеек
        let numberOfItemsPerRow: CGFloat = Constants.numberOfDaysInWeek // Количество ячеек в строке
        let itemWidth = availableWidth / numberOfItemsPerRow // Ширина каждой ячейки
        collectionAdapter.collectionViewCellSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func prepareTableView() {
        tableView.dataSource = tableAdapter
        tableView.delegate = tableAdapter
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    private func prepareCollectionView() {
        collectionView.dataSource = collectionAdapter
        collectionView.delegate = collectionAdapter
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
    }
    
    private func startLoading() {
        presentActivityIndicator()
    }
    
    private func stopLoading() {
        hideActivityIndicator()
    }
    
    // TODO: Error alert
    private func showErrorAlert() {
    }
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        presenter.addTaskButtonTapped()
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
            tableAdapter.tasks = tasksResponse.tasks
            tableView.reloadData()
        case .failure(let error):
            stopLoading()
            showErrorAlert()
        default:
            stopLoading()
        }
    }
    
    func addEvent(taskItem: TasksItem?) {
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
    
    func removeEventViews() {
        for eventView in eventViews {
            eventView.removeFromSuperview()
        }
        eventViews.removeAll()
        tableView.reloadData()
        collectionView.reloadData()
    }
}
