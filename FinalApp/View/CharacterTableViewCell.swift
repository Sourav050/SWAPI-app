import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {
    //TODO
    enum CellConstants {
        static let leadingtrailingConstant: CGFloat = 15
        static let spacingOffset: CGFloat = -20
        static let imageHeight: CGFloat = 60
        static let characterImageURL = "https://media.istockphoto.com/id/636208094/photo/tropical-jungle.jpg?s=1024x1024&w=is&k=20&c=Zyc6mQ-VrbJIVjPOhrdzKlr6CpUdpcqT__bPJHJemXI="
    }
    
    static let identifier = "CharacterTableViewCell"
    
    // MARK: - UI Elements
    
    // Image view to display the character's image
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Label to display the character's name
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews to the cell's content view
        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        
        // Apply layout constraints
        applyConstraints()
    }
    
    // Required initializer for using with Storyboard or Nib files
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Apply layout constraints to subviews
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for characterImageView
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellConstants.leadingtrailingConstant),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellConstants.leadingtrailingConstant),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellConstants.leadingtrailingConstant),
            characterImageView.heightAnchor.constraint(equalToConstant: CellConstants.imageHeight),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor, multiplier: 1), // Set width to be equal to height
            
            // Constraints for characterNameLabel
            characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: CellConstants.leadingtrailingConstant),
            characterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellConstants.leadingtrailingConstant),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellConstants.leadingtrailingConstant),
            characterNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: CellConstants.leadingtrailingConstant)
        ])
    }
    
    // MARK: - Configuration
    
    // Configure cell with character data
    func configure(with character: Person) {
        // Set character image using SDWebImage for asynchronous image loading
        if let imageURL = URL(string: CellConstants.characterImageURL) {
            characterImageView.sd_setImage(with: imageURL, completed: nil)
        }
        
        // Set character name
        characterNameLabel.text = character.name
    }
}
