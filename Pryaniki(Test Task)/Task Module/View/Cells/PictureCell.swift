import UIKit

final class PictureCell: UITableViewCell {
    
    // MARK: - Private constants
    
    private enum Constants {
        enum PictureView {
            static let width: CGFloat = 200
            static let height: CGFloat = 200
        }
        
        enum TitleLabel {
            static let topIndent: CGFloat = 12
            static let leftRightIndent: CGFloat = 8
        }
    }
    
    static let identifier: String = "PictureCell"
    
    private let pictureView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConfigurations()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Internal methods
    
    func configure(configureData: ViewInfoData) {
        if let imageData = configureData.imageData {
            pictureView.image = UIImage(data: imageData)
        } else {
            pictureView.image = UIImage(systemName: "star")
        }
        titleLabel.text = configureData.text
    }
    
    // MARK: - Private methods
    
    private func setupConfigurations() {
        [pictureView, titleLabel].forEach { subview in
            contentView.addSubview(subview)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            pictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureView.widthAnchor.constraint(equalToConstant: Constants.PictureView.width),
            pictureView.heightAnchor.constraint(equalToConstant: Constants.PictureView.height),
            
            titleLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: Constants.TitleLabel.topIndent),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.TitleLabel.leftRightIndent),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.TitleLabel.leftRightIndent),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.TitleLabel.topIndent),
        ])
    }
}
