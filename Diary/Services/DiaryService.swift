import Foundation

protocol DiaryServiceProtocol {
    func getTasks(completion: @escaping (Result<TasksResponse, Error>) -> Void)
    func addTask(_ model: AddTaskRequestModel.Data, completion: @escaping (Result<TasksResponse, Error>) -> Void)
}

final class DiaryService {

}

extension DiaryService: DiaryServiceProtocol {
    func addTask(_ model: AddTaskRequestModel.Data, completion: @escaping (Result<TasksResponse, any Error>) -> Void) {
        print("dataToSend: \(model)")
    }
    
    func getTasks(completion: @escaping (Result<TasksResponse, any Error>) -> Void) {
        let urlString = "https://jsonhost.com/json/242ecff29a7d3d9b6b17e5d681e11fd9"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(TasksResponse.self, from: data ?? Data([]))
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
