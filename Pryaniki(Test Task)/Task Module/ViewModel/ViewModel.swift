import UIKit

enum ViewModelError {
    case failedLoadMainData(NetworkError)
    case failedToDecodeMainData(Error)
    case failedLoadImage(NetworkError)
}

protocol ViewModelProtocol {
    var mainData: MainResponseData? { get }
    var mainDataDidChange: (() -> ())? { get set }
    
    var error: ViewModelError? { get }
    var errorDataDidChange: (() -> ())? { get set }
    
    var viewIndexesSequence: [Int] { get }
    
    func fetchMainData()
}

final class ViewModel: ViewModelProtocol {

    // MARK: - Intarnal properties
    
    var mainDataDidChange: (() -> ())?
    var mainData: MainResponseData? {
        didSet {
            DispatchQueue.main.async {
                self.mainDataDidChange?()
            }
        }
    }
    
    var viewIndexesSequence: [Int] = []
    
    var errorDataDidChange: (() -> ())?
    var error: ViewModelError? {
        didSet {
            DispatchQueue.main.async {
                self.errorDataDidChange?()
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
                            self?.countNumberOfViews(data: data)
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
    
    private func countNumberOfViews(data: MainResponseData) {
        viewIndexesSequence = []
        mainData?.view.forEach { stringType in
            mainData?.data.enumerated().forEach { index, viewInfo in
            
                if viewInfo.name == stringType {
                    viewIndexesSequence.append(index)
                }
            }
        }
    }
    
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
