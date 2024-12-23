import Foundation
import UIKit
import SnapKit

protocol AddTaskScreenViewInput: AnyObject {
    func handleState(_ state: AddTaskScreenModels.State)
}

protocol AddTaskScreenPresenterProtocol {
    func viewDidLoad()
    func valueChanged(inputType: InputType, value: String)
    func tappedActionButton()
}

final class AddTaskScreenViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let presenter: AddTaskScreenPresenterProtocol
    private let tableAdapter: AddTaskScreenTableAdapter
    private var inputFields = [UIView]()
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
        
        tableView.register(
            TitleDescriptionTableViewCell.self,
            forCellReuseIdentifier: TitleDescriptionTableViewCell.identifier
        )
        
        tableView.register(
            TextInputTableViewCell.self,
            forCellReuseIdentifier: TextInputTableViewCell.identifier
        )
        
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
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextInputTableViewCell.identifier, for: indexPath)
        switch indexPath.row {
        case 0:
            if let reusableCell = cell as? TextInputTableViewCell {
                reusableCell.configureCell(inputType: .title)
                reusableCell.delegate = self
                if inputFields.indices.contains(indexPath.row) {
                    inputFields[indexPath.row] = reusableCell.textInputField
                } else {
                    inputFields.append(reusableCell.textInputField)
                }
                reusableCell.textInputField.becomeFirstResponder()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextInputTableViewCell.identifier, for: indexPath)
            if let reusableCell = cell as? TextInputTableViewCell {
                reusableCell.configureCell(inputType: .description)
                reusableCell.delegate = self
                if inputFields.indices.contains(indexPath.row) {
                    inputFields[indexPath.row] = reusableCell.textInputField
                } else {
                    inputFields.append(reusableCell.textInputField)
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}


// MARK: - TextInputTableViewCellDelegate

extension AddTaskScreenViewController: TextInputTableViewCellDelegate {
    func textFieldDidChange(in cell: TextInputTableViewCell) {
        presenter.valueChanged(
            inputType: cell.inputType,
            value: cell.text
//            inputType: cell.inputType,
//            validationStatus: cell.validationStatus ?? .notValidated,
//            value: cell.text
        )
    }
    
    func textFieldDidReturn(in cell: TextInputTableViewCell) {
        if cell.textInputField == inputFields.last {
            tableView.endEditing(true)
            presenter.tappedActionButton()
        } else {
            if let index = inputFields.firstIndex(of: cell.textInputField) {
                inputFields[index+1].becomeFirstResponder()
            }
        }
    }
}
