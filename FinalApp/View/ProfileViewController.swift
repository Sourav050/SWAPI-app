//Currently Working on this Part
import UIKit
import CoreLocation


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    private var viewModel: ProfileViewModel
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var editButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self?.changeProfilePicture), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Enter your Name"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var editNameButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self?.editName), for: .touchUpInside)
        return button
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var fetchLocationButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "location.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self?.fetchUserLocation), for: .touchUpInside)
        return button
    }()
    
    private let designationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Enter your Designation"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var editDesignationButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self?.editDesignation), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(nameTextField)
        view.addSubview(editNameButton)
        view.addSubview(designationTextField)
        view.addSubview(editDesignationButton)
        view.addSubview(locationLabel)
        view.addSubview(fetchLocationButton)
        
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        
        let profileData = viewModel.loadProfileData()
        nameTextField.text = profileData.name
        designationTextField.text = profileData.designation
        if let location = profileData.location, !location.isEmpty {
            locationLabel.text = "Location: \(location)"
        } else {
            locationLabel.text = "Location: Unknown"
        }
        profileImageView.image = profileData.image
        
//        NotificationCenter.default.addO
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        orientationChanged()
    }
    
    @objc func orientationChanged() {
        updateConstraintsForOrientation()
    }
    
    func updateConstraintsForOrientation() {
        if UIDevice.current.orientation.isLandscape{
            applyLandscapeConstraints()
        } else {
            applyPortraitConstraints()
        }
    }
    
    func applyPortraitConstraints() {
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.activate(portraitConstraints)
    }
    
    func applyLandscapeConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private lazy var portraitConstraints: [NSLayoutConstraint] = [
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        profileImageView.widthAnchor.constraint(equalToConstant: 150),
        profileImageView.heightAnchor.constraint(equalToConstant: 150),
        
        editButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
        editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        editNameButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
        editNameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        designationTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
        designationTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        designationTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        editDesignationButton.centerYAnchor.constraint(equalTo: designationTextField.centerYAnchor),
        editDesignationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        locationLabel.topAnchor.constraint(equalTo: designationTextField.bottomAnchor, constant: 20),
        locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        
        fetchLocationButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
        fetchLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ]
    
    private lazy var landscapeConstraints: [NSLayoutConstraint] = [
        profileImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        profileImageView.widthAnchor.constraint(equalToConstant: 150),
        profileImageView.heightAnchor.constraint(equalToConstant: 150),
        
        editButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
        editButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
        
        nameTextField.topAnchor.constraint(equalTo: profileImageView.topAnchor),
        nameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        editNameButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
        editNameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        designationTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
        designationTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
        designationTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
        
        editDesignationButton.centerYAnchor.constraint(equalTo: designationTextField.centerYAnchor),
        editDesignationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        locationLabel.topAnchor.constraint(equalTo: designationTextField.bottomAnchor, constant: 20),
        locationLabel.leadingAnchor.constraint(equalTo: designationTextField.leadingAnchor),
        locationLabel.trailingAnchor.constraint(equalTo: designationTextField.trailingAnchor),
        locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        
        fetchLocationButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
        fetchLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        fetchLocationButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ]
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        updateConstraintsForOrientation()
//    }
//    
    @objc func fetchUserLocation() {
        viewModel.fetchLocation()
    }
    
    @objc func changeProfilePicture() {
        let alertController = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { [weak self] _ in
            self?.openGallery()
        }
        
        let cameraAction = UIAlertAction(title: "Take a Picture", style: .default) {[weak self] _ in
            self?.openCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Camera Not Available", message: "Sorry, camera is not available on this device.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        saveProfileData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    var isEditingName = false
    
    @objc func editName() {
        if isEditingName {
            nameTextField.isUserInteractionEnabled = false
            nameTextField.borderStyle = .none
            isEditingName = false
            editNameButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            editNameButton.tintColor = .white
            
        } else {
            nameTextField.isUserInteractionEnabled = true
            nameTextField.borderStyle = .roundedRect
            isEditingName = true
            editNameButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            editNameButton.tintColor = .green
        }
        saveProfileData()
    }
    
    var isEditingDesignation = false
    
    @objc func editDesignation() {
        if isEditingDesignation {
            designationTextField.isUserInteractionEnabled = false
            designationTextField.borderStyle = .none
            isEditingDesignation = false
            editDesignationButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            editDesignationButton.tintColor = .white

        } else {
            designationTextField.isUserInteractionEnabled = true
            designationTextField.borderStyle = .roundedRect
            isEditingDesignation = true
            editDesignationButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            editDesignationButton.tintColor = .green

        }
        saveProfileData()
    }
}

extension ProfileViewController : ProfileViewModelDelegate {
    func didFetchLocation(_ location: CLLocation) {
        DispatchQueue.main.async {
            let formattedLatitude = String(format: "%.2f", location.coordinate.latitude)
            let formattedLongitude = String(format: "%.2f", location.coordinate.longitude)
            
            self.locationLabel.text = "Location: \(formattedLatitude), \(formattedLongitude)"
            self.saveProfileData()
        }
    }
    
    func didFailToFetchLocation(_ error: Error) {
        print("Failed to fetch location: \(error)")
        
    }
    
    func saveProfileData() {
        let name = nameTextField.text
        let designation = designationTextField.text
        let location = locationLabel.text
        let profileImage = profileImageView.image
        viewModel.saveProfileData(name: name, designation: designation, location: location, image: profileImage)
    }
}
