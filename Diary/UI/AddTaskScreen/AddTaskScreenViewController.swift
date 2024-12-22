import Foundation
import UIKit
import SnapKit

protocol AddTaskScreenViewInput: AnyObject {
    func handleState(_ state: AddTaskScreenModels.State)
}

protocol AddTaskScreenPresenterProtocol {
    func viewDidLoad()
}

final class AddTaskScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let presenter: AddTaskScreenPresenterProtocol
    private let tableAdapter: AddTaskScreenTableAdapter
    
    // MARK: - Lifecycle
    
    init(
        presenter: AddTaskScreenPresenterProtocol,
        tableAdapter: AddTaskScreenTableAdapter
    ) {
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
        title = "AddTaskScreen.Title".localized
        prepareView()
    }
    
    // MARK: - Private methods
    
    private func prepareView() {
        view.addSubview(tableView)
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AddTaskScreenViewController: AddTaskScreenViewInput {
    func handleState(_ state: AddTaskScreenModels.State) {
        switch state {
        case .success:
            tableView.reloadData()
        default:
            return
        }
    }
}

// MARK: - UITableViewDelegate

extension AddTaskScreenViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension AddTaskScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
