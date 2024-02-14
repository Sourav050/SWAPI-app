import UIKit



class SplashViewController: UIViewController {
    
    // MARK: - UI Elements
    
    enum SplashScreenConstants {
        enum FontSize {
            static let title: CGFloat = 50
        }
        
        enum Delay {
            static let screen: TimeInterval = 2.0
        }
        
        enum Image {
            static let widthMultiplier: CGFloat = 0.8
        }
        
        enum Label {
            static let spacing: CGFloat = 20
            static let leadingTrailingSpacing: CGFloat = -20
        }
        static let appTitle = "Star Wars"
        static let appImage = "SplashScreen"
    }
    
    // ImageView to display the splash screen image
    let imageView: UIImageView = {
        let image = UIImage(named: SplashScreenConstants.appImage)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label to display the app title
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Lifecycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Load app title from strings file
        textLabel.text = SplashScreenConstants.appTitle
        
        // Apply font
        textLabel.font = UIFont.boldSystemFont(ofSize: SplashScreenConstants.FontSize.title)
        
        // Add UI elements to the view
        view.addSubview(imageView)
        view.addSubview(textLabel)
        
        // Apply layout constraints
        applyConstraints()
        
        // Navigate to the main screen after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + SplashScreenConstants.Delay.screen) {
            self.navigateToMainScreen()
        }
    }
    
    // MARK: - Layout Constraints
    
    // Apply layout constraints to UI elements
    private func applyConstraints() {
        // Image View Constraints
        let imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: SplashScreenConstants.Image.widthMultiplier), // Adjust multiplier as needed
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // Maintain aspect ratio
        ]
        
        // Text Label Constraints
        let textLabelConstraints = [
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: SplashScreenConstants.Label.spacing), // Place below imageView with spacing
            textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: -SplashScreenConstants.Label.leadingTrailingSpacing), // Ensure it doesn't overflow left
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: SplashScreenConstants.Label.leadingTrailingSpacing), // Ensure it doesn't overflow right
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: SplashScreenConstants.Label.leadingTrailingSpacing) // Ensure it doesn't overflow bottom
        ]
        
        // Activate Constraints
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(textLabelConstraints)
    }

    // MARK: - Navigation
    // Navigate to the main screen
    func navigateToMainScreen() {
        let viewModel = CharactersViewModel()
        let homeVC = CharactersVC(viewModel: viewModel)
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
