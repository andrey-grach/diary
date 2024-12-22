import UIKit

final class TaskDetailScreenViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let presenter: TaskDetailScreenPresenterProtocol
    private let tableAdapter: TaskDetailScreenTableAdapter
    
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
        tableView.delegate = tableAdapter
        tableView.dataSource = tableAdapter
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
}

extension TaskDetailScreenViewController: TaskDetailScreenViewInput {
    func handleState(_ state: TaskDetailScreenModels.State) {
        switch state {
        case .success(let currentTask):
            tableAdapter.currentTask = currentTask
            tableView.reloadData()
        default:
            return
        }
    }
}
