import UIKit

final class TaskDetailScreenViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let presenter: TaskDetailScreenPresenterProtocol
    private let tableAdapter: TaskDetailScreenTableAdapter
    private var currentTask: TasksItem? = nil
    
    init(presenter: TaskDetailScreenPresenterProtocol, tableAdapter: TaskDetailScreenTableAdapter) {
        self.presenter = presenter
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TaskDetailScreen.Title".localized
        presenter.viewDidLoad()
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.register(TaskDetailTableViewCell.nib(), forCellReuseIdentifier: TaskDetailTableViewCell.identifier)
    }
}

extension TaskDetailScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TaskDetailScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailTableViewCell.identifier, for: indexPath)
        if let reusableCell = cell as? TaskDetailTableViewCell {
            guard let currentTask else { return UITableViewCell() }
            reusableCell.configureCellWith(
                data: .init(
                    title: currentTask.name,
                    date: currentTask.dateStart,
                    description: currentTask.description
                )
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

extension TaskDetailScreenViewController: TaskDetailScreenViewInput {
    func handleState(_ state: TaskDetailScreenModels.State) {
        switch state {
        case .success(let currentTask):
            self.currentTask = currentTask
            tableView.reloadData()
        default:
            return
        }
    }
}
