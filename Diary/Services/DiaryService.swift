import Foundation

protocol DiaryServiceProtocol {
    func getTasks(completion: @escaping (Result<TasksResponse, Error>) -> Void)
}

final class DiaryService {

}

extension DiaryService: DiaryServiceProtocol {
    func getTasks(completion: @escaping (Result<TasksResponse, any Error>) -> Void) {
        let urlString = "https://jsonhost.com/json/18e93f834f1908bee5dac2e6dd0520f1"
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
