import UIKit
import Network

class CharactersVC: UIViewController {
    enum Constants {
        static let spacingOffset: CGFloat = -10
        static let defaultErrorMessage = "Error: Unable to fetch characters"
        static let noInternetErrorMessage = "Check Your Internet Connection"
        static let appTitle = "Star Wars"
    }
    
    // MARK: - Properties
    // TableView to display characters
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // who calls this closure
    private let centerActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private let tableActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private var viewModel: CharactersViewModel // View model for managing characters
    
    // MARK: - Initializers
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Add TableView to the view and set its data source and delegate
        view.addSubview(tableView)
        view.addSubview(centerActivityIndicator)
        view.addSubview(tableActivityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = Constants.appTitle
        
        navigationController?.navigationBar.tintColor = .white
        
        
        // Fetch characters when view loads
        viewModel.delegate = self
        viewModel.fetchNextPage()
        
        applyConstraints()
        
        // Start the center activity indicator
        centerActivityIndicator.startAnimating()
    }
    
    
    // MARK: - Methods
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableActivityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.spacingOffset)
        ])
    }
    
    private func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source and Delegate Methods

extension CharactersVC: UITableViewDataSource, UITableViewDelegate {
    
    // Number of rows in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCharacters
    }
    
    // Configure cells in TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = viewModel.characterAtIndex(indexPath.row)
        cell.configure(with: character)
        return cell
    }
    
    // Handle selection of TableView rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characterAtIndex(indexPath.row)
        
        let characterDetailViewModel = CharacterDetailViewModel(character: character)
        let characterDetailsVC = CharacterDetailVC(viewModel: characterDetailViewModel)
        
        if UIDevice.current.orientation.isLandscape {
            
            for childVC in children {
                childVC.view.removeFromSuperview()
                childVC.removeFromParent()
            }
            
            let halfScreenWidth = UIScreen.main.bounds.width/2
            
            let characterDetailsHeight = tableActivityIndicator.frame.origin.y
            
            // Adjust the width of the characterDetailsVC view
            let characterDetailsFrame = CGRect(x: halfScreenWidth, y: 0, width: halfScreenWidth, height: characterDetailsHeight)
            characterDetailsVC.view.frame = characterDetailsFrame
            
            // Add characterDetailsVC as a child view controller
            addChild(characterDetailsVC)
            view.addSubview(characterDetailsVC.view)
            characterDetailsVC.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -halfScreenWidth),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
            ])
                        
        } else {
            navigationController?.pushViewController(characterDetailsVC, animated: true)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.isSelected = false
            }
            
        }
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
            ])
            
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
            ])

        }else {
            for childVC in children {
                childVC.view.removeFromSuperview()
                childVC.removeFromParent()
            }
            NSLayoutConstraint.deactivate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width/2),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
            ])
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: tableActivityIndicator.topAnchor)
            ])
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the displayed cell is the last cell
        if indexPath.row == viewModel.numOfCharacters - 1 {
            
            if viewModel.isInternetAvailable {
                tableActivityIndicator.startAnimating()
                viewModel.fetchNextPage()
            } else {
                self.displayError(message: Constants.noInternetErrorMessage)
            }
        }
    }
}

// MARK: - CharactersViewModelDelegate Methods

extension CharactersVC: CharactersViewModelDelegate {
    func didFetchCharactersSuccessfully() {
        DispatchQueue.main.async {
            // Reload table view data to reflect changes
            self.tableView.reloadData()
            self.centerActivityIndicator.stopAnimating()
            self.tableActivityIndicator.stopAnimating()
        }
    }
    
    func didFailToFetchCharactersWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.centerActivityIndicator.stopAnimating()
            self.tableActivityIndicator.stopAnimating()
            
            if let networkError = error as? NetworkError {
                if networkError == .noInternetConnection {
                    self.displayError(message: Constants.noInternetErrorMessage)
                }
            }
        }
    }
}
