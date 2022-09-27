import UIKit

final class TaskModuleBuilder {
    func build() -> UIViewController {
        let networkService = NetworkService(session: URLSession(configuration: .default))
        
        let view = ViewController()
        let viewModel = ViewModel(networkService: networkService)
        
        view.viewModel = viewModel
        
        return view
    }
}
