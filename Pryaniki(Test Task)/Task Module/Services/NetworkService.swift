import Foundation

enum NetworkError: Error {
    case noData
    case transportError(Error)
    case serverError(statusCode: Int)
}

protocol NetworkServiceProtocol {
    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
}
