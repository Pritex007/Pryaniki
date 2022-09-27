import UIKit

final class TextCell: UITableViewCell {
    
    // MARK: - Private constants
    
    private enum Constants {
        static let leftRightIndent: CGFloat = 8
    }
    
    static let identifier: String = "TextCell"
    
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func configure(configureData: ViewInfoData) {
        titleLabel.text = configureData.text
    }
    
    // MARK: - Private methods
    
    private func setupConfigurations() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.leftRightIndent),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leftRightIndent)
        ])
    }
}
