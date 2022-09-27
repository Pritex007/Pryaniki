import UIKit

enum ViewModelError {
    case failedLoadMainData(NetworkError)
    case failedToDecodeMainData(Error)
    case failedLoadImage(NetworkError)
}

protocol ViewModelProtocol {
    var mainData: MainResponseData? { get }
    var mainDataDidChange: ((ViewModelProtocol) -> ())? { get set }
    
    var error: ViewModelError? { get }
    var errorDataDidChange: ((ViewModelProtocol) -> ())? { get set }
    
    func fetchMainData()
}

final class ViewModel: ViewModelProtocol {

    // MARK: - Intarnal properties
    
    var mainDataDidChange: ((ViewModelProtocol) -> ())?
    var mainData: MainResponseData? {
        didSet {
            DispatchQueue.main.async {
                self.mainDataDidChange?(self)
            }
        }
    }
    
    var errorDataDidChange: ((ViewModelProtocol) -> ())?
    var error: ViewModelError? {
        didSet {
            DispatchQueue.main.async {
                self.errorDataDidChange?(self)
            }
        }
    }
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let defaulrURLRequest: URLRequest = URLRequest(url: URL(string: "https://chat.pryaniky.com/json/data-custom-order-much-more-items-in-data.json")!)
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Intarnal methods
    
    func fetchMainData() {
        networkService.sendRequest(defaulrURLRequest) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = ViewModelError.failedLoadMainData(error)
                print("Failed to sendRequest \(error)")
            case .success(let rawData):
                do {
                    let decoder = JSONDecoder()
                    var data: MainResponseData = try decoder.decode(MainResponseData.self, from: rawData)
                    for (index, viewInfo) in data.data.enumerated() where viewInfo.name == ViewController.ViewType.picture.rawValue {
                        guard let stringURL = viewInfo.data.url
                        else {
                            return
                        }
                        self?.fetchImage(stringURL: stringURL) { [weak self] imageData in
                            data.data[index].data.imageData = imageData
                            self?.mainData = data
                        }
                    }
                } catch {
                    self?.error = .failedToDecodeMainData(error)
                    print("Decoding failure: \(error)")
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func fetchImage(stringURL: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: stringURL) else { return }
        let request = URLRequest(url: url)
        networkService.sendRequest(request) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Failed to sendRequest \(error)")
                self?.error = ViewModelError.failedLoadImage(error)
            case .success(let data):
                completion(data)
            }
        }
    }
}
