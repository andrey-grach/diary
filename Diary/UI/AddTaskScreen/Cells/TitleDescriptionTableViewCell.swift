import Foundation
import UIKit
import SnapKit

final class TitleDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TitleDescriptionTableViewCell"
    
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public methods
    
    func configureCell() {
        selectionStyle = .none
        contentView.addSubviews(titleLabel, descriptionLabel)
        prepareTitleLabel()
        prepareDescriptionLabel()
    }
    
    // MARK: - Private methods
    
    private func prepareTitleLabel() {
        titleLabel.text = "Название дела"
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func prepareDescriptionLabel() {
        descriptionLabel.text = "Описание дела"
    }
}
