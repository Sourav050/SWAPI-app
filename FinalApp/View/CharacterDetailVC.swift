import UIKit
import SDWebImage

class CharacterDetailVC: UIViewController {
    
    // MARK: - Properties
    enum Detail {
        enum Font {
            static let detailLabel = UIFont.systemFont(ofSize: 16)
        }
        
        enum Color {
            static let detailLabelText = UIColor.white
        }
        
        enum Layout {
            static let detailLabelSpacing: CGFloat = 20
            static let LeadingTrailingConstant: CGFloat = 20
            static let heroImageViewHeightMultiplier: CGFloat = 0.45
        }
        static let characterImageURL = "https://media.istockphoto.com/id/636208094/photo/tropical-jungle.jpg?s=1024x1024&w=is&k=20&c=Zyc6mQ-VrbJIVjPOhrdzKlr6CpUdpcqT__bPJHJemXI="
    }
    
    var viewModel: CharacterDetailViewModel
    
    // MARK: - UI Elements
    
    // Scroll view to contain all the content
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // Container view to hold all the content inside the scroll view
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Image view to display the character's image
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Stack view to organize character details
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Detail.Layout.detailLabelSpacing
        return stackView
    }()
    
    // MARK: - Initializers
    
    // Initializer to inject the view model
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.character.name
        
        // Add scroll view to the view
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // Add UI elements to the container view
        containerView.addSubview(heroImageView)
        containerView.addSubview(detailsStackView)
        
        // Apply layout constraints
        applyConstraints()
        
        // Configure and add labels for character details
        configureLabels()
        
        // Load character image
        if let imageUrlString = Detail.characterImageURL as String?, let imageUrl = URL(string: imageUrlString) {
            heroImageView.sd_setImage(with: imageUrl)
        } else {
            print("Error: Invalid image URL")
        }
         
        // Customize navigation bar
        navigationController?.navigationBar.tintColor = .white
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func configureLabels(){
        addDetailLabel(title: "Height", value: viewModel.character.height)
        addDetailLabel(title: "Mass", value: viewModel.character.mass)
        addDetailLabel(title: "Hair Color", value: viewModel.character.hair_color)
        addDetailLabel(title: "Skin Color", value: viewModel.character.skin_color)
        addDetailLabel(title: "Eye Color", value: viewModel.character.eye_color)
        addDetailLabel(title: "Birth Year", value: viewModel.character.birth_year)
        addDetailLabel(title: "Gender", value: viewModel.character.gender)
    }
    
    // MARK: - Layout Constraints
    
    // Apply layout constraints to UI elements
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Hero image view constraints
            heroImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            heroImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            heroImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: Detail.Layout.heroImageViewHeightMultiplier),
            
            // Details stack view constraints
            detailsStackView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: Detail.Layout.detailLabelSpacing),
            detailsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Detail.Layout.LeadingTrailingConstant),
            detailsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Detail.Layout.LeadingTrailingConstant),
            detailsStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Detail.Layout.LeadingTrailingConstant)
        ])
    }

    
    // MARK: - Helper Methods
    
    // Add a label for character detail to the stack view
    private func addDetailLabel(title: String, value: String?) {
        guard let value = value else { return }
        
        let detailString = "\(title): \(value)"
        
        let detailLabel = UILabel()
        detailLabel.text = detailString
        detailLabel.numberOfLines = 0
        detailLabel.font = Detail.Font.detailLabel
        detailLabel.textColor = Detail.Color.detailLabelText
        
        detailsStackView.addArrangedSubview(detailLabel)
    }
    
    // MARK: - Button Action
    
    // Action when share button is tapped
    @objc func shareButtonTapped() {
        let character = viewModel.character
        
        // Prepare text to share
        let textToShare = "\(character.name)\nHeight: \(character.height)\nMass: \(character.mass)\nHair Color: \(character.hair_color)\nSkin Color: \(character.skin_color)\nEye Color: \(character.eye_color)\nBirth Year: \(character.birth_year)\nGender: \(character.gender)"
        
        // Show activity view controller to share text
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}
