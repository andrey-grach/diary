import Foundation

final class AddTaskScreenPresenter {
    
    // MARK: - Properties
    
    weak var view: AddTaskScreenViewInput?
    
    // MARK: - Private Properties
    
    private let router: AddTaskScreenRouterProtocol
    private let service: DiaryServiceProtocol
//    private let modelEditing = AddTaskRequestModel.Data()
    private var modelEditing = AddTaskRequestModel.Data(title: "Заголовок задачи", description: "Описание задачи", time: "12:00")

    private(set) var state: AddTaskScreenModels.State = .default {
        didSet {
            view?.handleState(state)
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        router: AddTaskScreenRouterProtocol,
        service: DiaryServiceProtocol
    ) {
        self.router = router
        self.service = service
    }
}

extension AddTaskScreenPresenter: AddTaskScreenPresenterProtocol {
    func viewDidLoad() {
        state = .success
    }
    
    func valueChanged(inputType: InputType, value: String) {
        switch inputType {
        case .title:
            modelEditing.title = value
        case .description:
            modelEditing.description = value
        default:
            return
        }
    }
    
    func tappedActionButton() {
        service.addTask(
            modelEditing,
            completion: { [weak self] result in
                print(result)
            }
        )
    }
    //    func valueChanged(inputType: InputType, validationStatus: ValidationStatus, value: String?) {
    //        switch inputType {
    //        case .name:
    //            modelEditing.name = value
    //        case .email:
    //            modelEditing.email = value
    //        case .phone:
    //            modelEditing.phone = FormattedStringHelper.clean(value)
    //        default:
    //            return
    //        }
    //        validationStatuses[inputType] = validationStatus
    //
    //        let isNameValid = modelEditing.name != nil && validationStatuses[.name] == .valid
    //        let isEmailValid = modelEditing.email != nil && validationStatuses[.email] == .valid
    //        let isPhoneValid = modelEditing.phone != nil && validationStatuses[.phone] == .valid
    //        // Кол-во заполненных полей в момент редактирования формы обращения
    //        let count = [isNameValid, isEmailValid, isPhoneValid].filter { $0 }.count
    //        let isEmpty = modelEditing.name.isNilOrEmpty() || modelEditing.email.isNilOrEmpty() || modelEditing.phone.isNilOrEmpty()
    //        state = .formValidation(
    //            isUserDataEntered,
    //            // Флаг замены сообщения с ошибкой при условии, на момент редактирования 3-го поля были уже заполнены 2 поля и их значение валидное
    //            (count == 2 && !isEmpty) && !validationStatuses.values.contains(where: { $0 == .notValidated }) ? true : false
    //        )
    //    }
}
