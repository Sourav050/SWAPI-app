import Foundation
import CoreLocation
import UIKit

protocol ProfileViewModelDelegate: AnyObject { // here i am using AnyObject because it allows only refrence type to adopt the delegate
    func didFetchLocation(_ location: CLLocation)
    func didFailToFetchLocation(_ error: Error)
}


class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    private let locationManager: LocationManager
    let imageKey = "userProfileImage"
    
    let userDefaults = UserDefaults.standard
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func fetchLocation() {
        locationManager.getUserLocation { result in
            switch result {
            case .success(let location):
                self.delegate?.didFetchLocation(location)
            case .failure(let error):
                self.delegate?.didFailToFetchLocation(error)
            }
        }
    }
    
    func saveProfileData(name: String?, designation: String?, location: String?, image: UIImage?) {
        userDefaults.set(name, forKey: "userName")
        userDefaults.set(designation, forKey: "userDesignation")
        userDefaults.set(location, forKey: "userLocation")
        
        if let image = image, let imageData = image.pngData() {
            let fileManager = FileManager.default
            do {
                let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let fileURL = documentsDirectory.appendingPathComponent("profileImage.png")
                try imageData.write(to: fileURL)
                userDefaults.set(fileURL, forKey: imageKey)

            } catch {
                print("Error saving image:", error)
            }
        }
    }
    
    func loadProfileData() -> (name: String?, designation: String?, location: String?, image: UIImage?) {
        let name = userDefaults.string(forKey: "userName")
        let designation = userDefaults.string(forKey: "userDesignation")
        let location = userDefaults.string(forKey: "userLocation")
        
        var image: UIImage?
        if let imageUrl = userDefaults.url(forKey: imageKey) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                image = UIImage(data: imageData)
            } catch {
                print("Error loading image:", error)
            }
        }
        
        return (name, designation, location, image)
    }
}
