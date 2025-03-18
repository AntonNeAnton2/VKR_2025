import UIKit

final class LibraryTableViewCell: UITableViewCell, NibProvidable, ReusableView {

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
// MARK: Other properties
    var myStory: MyStory? {
        didSet {
            guard let myStory = self.myStory else { return }
            self.configure(with: myStory)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
}

// MARK: - Setup
private extension LibraryTableViewCell {
    
    func setupUI() {
        self.cellBackgroundView.layer.cornerRadius = 15
        self.titleLabel.font = FontFamily.Montserrat.semiBold.font(size: 14)
        self.descriptionLabel.font = FontFamily.Montserrat.regular.font(size: 12)
        self.dateLabel.font = FontFamily.Montserrat.regular.font(size: 10)
    }
}

// MARK: - Configure
private extension LibraryTableViewCell {
    
    func configure(with myStory: MyStory) {
        self.titleLabel.text = myStory.name
        self.descriptionLabel.text = myStory.description
        self.dateLabel.text = myStory.dateString
    }
}
