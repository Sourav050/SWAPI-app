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
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Load app title from strings file
        
        // Apply font
        navigationController?.navigationBar.isHidden = true
        // Add UI elements to the view
        view.addSubview(imageView)
        
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
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: SplashScreenConstants.Image.widthMultiplier),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        
        // Activate Constraints
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    // MARK: - Navigation
    // Navigate to the main screen
    
    // push, present and replace Just keep it in mind
    func navigateToMainScreen() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
}
