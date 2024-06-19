import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Instantiate view models
        let charactersViewModel = CharactersViewModel()
        let profileViewModel = ProfileViewModel(locationManager: LocationManager())
        
        // Instantiate view controllers with view models
        let viewController1 = UINavigationController(rootViewController: CharactersVC(viewModel: charactersViewModel))
        let viewController2 = UINavigationController(rootViewController: ProfileViewController(viewModel: profileViewModel))
        
        viewController1.tabBarItem.image = UIImage(systemName: "list.bullet")
        viewController2.tabBarItem.image = UIImage(systemName: "person")
        
        viewController1.title = "Character"
        viewController2.title = "Profile"
        
        tabBar.tintColor = .label
        
        setViewControllers([viewController1, viewController2], animated: true)
    }
}
