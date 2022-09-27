import UIKit

final class SelectorCell: UITableViewCell {
    
    // MARK: - Private constants
    
    private enum Constants {
        enum SegmentedControl {
            static let width: CGFloat = 300
            static let height: CGFloat = 50
        }
    }
    
    static let identifier: String = "SelectorCell"
    
    var showAlert: ((_ message: String) -> ())?
    
    private let segmentedControl: UISegmentedControl = UISegmentedControl(items: nil)
    private var selectorSegmentsData: [SelectorVariant] = []
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConfigurations()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        segmentedControl.removeAllSegments()
    }
    
    // MARK: - Internal methods
    
    func configure(configureData: ViewInfoData) {
        guard let variants = configureData.variants,
              let selectedID = configureData.selectedId
        else {
            return
        }
        
        for (index, variant) in variants.enumerated() {
            segmentedControl.insertSegment(withTitle: variant.text, at: index, animated: false)
            if variant.id == selectedID {
                segmentedControl.selectedSegmentIndex = index
            }
        }
        
        selectorSegmentsData = variants
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            segmentedControl.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupViews() {
        contentView.addSubview(segmentedControl)
    }
    
    private func setupConfigurations() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlTap), for: .valueChanged)
    }
    
    @objc
    private func segmentedControlTap() {
        let index = segmentedControl.selectedSegmentIndex
        showAlert?("\(ViewController.ViewType.selector.rawValue): Text - \(selectorSegmentsData[index].text)" )
    }
}
