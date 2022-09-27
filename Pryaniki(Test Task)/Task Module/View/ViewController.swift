import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Internal
    
    enum ViewType: String {
        case hz = "hz"
        case picture = "picture"
        case selector = "selector"
    }
    
    var viewModel: ViewModelProtocol?
    
    private let tableView: UITableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupConfigurations()
        view.backgroundColor = .systemBackground
        
        viewModel?.mainDataDidChange = { [weak self] viewModel in
            self?.tableView.reloadData()
        }
        viewModel?.fetchMainData()
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PictureCell.self, forCellReuseIdentifier: PictureCell.identifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.register(SelectorCell.self, forCellReuseIdentifier: SelectorCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    private func setupConfigurations() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Объект",
                                                message: message,
                                                preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Ok",
                                         style: .cancel)
        alertController.addAction(acceptAction)
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel?.mainData?.view.count else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rawCellType = viewModel?.mainData?.view[indexPath.row],
              let cellType = ViewType(rawValue: rawCellType),
              let configureData = viewModel?.mainData?.data.first(where: { $0.name == rawCellType })
        else {
            return UITableViewCell()
        }
        
        switch cellType {
        case .hz:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier) as? TextCell
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData.data)
            return cell
        case .picture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PictureCell.identifier) as? PictureCell
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData.data)
            return cell
        case .selector:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectorCell.identifier) as? SelectorCell
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData.data)
            cell.showAlert = { [weak self] message in
                self?.showAlert(message: message)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rawCellType = viewModel?.mainData?.view[indexPath.row],
              let cellType = ViewType(rawValue: rawCellType),
              cellType == .picture
        else {
            return 44
        }
        return 256
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let stringCellType = viewModel?.mainData?.view[indexPath.row],
              stringCellType != ViewType.selector.rawValue
        else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        showAlert(message: stringCellType)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
