import Foundation
import UIKit

protocol TasksScreenViewInput: AnyObject {
    func handleState(_ state: TasksScreenModels.State)
}

protocol TasksScreenPresenterProtocol {
    func viewDidLoad()
}

final class TasksScreenViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let presenter: TasksScreenPresenterProtocol
    private let tableAdapter: TasksScreenTableAdapter
    private var tasks: [TasksItem] = []
    private var calendarManager = CalendarManager.shared
    private var days: [(Date, Int)] = []
    
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
        days = calendarManager.getDaysInCurrentMonth()
    }
    
    private func prepareTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // TODO: Loading indicator
    private func startLoading() {
    }
    
    private func stopLoading() {
    }
    
    // TODO: Error alert
    private func showErrorAlert() {
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
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
}

extension TasksScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension TasksScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension TasksScreenViewController: UICollectionViewDelegateFlowLayout {
    // TODO: настройка лейаута
}
