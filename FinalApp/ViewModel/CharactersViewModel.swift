import Foundation
import CoreData
import Network

enum NetworkError: Error {
    case noInternetConnection
}

protocol CharactersViewModelDelegate: AnyObject {
    func didFetchCharactersSuccessfully()
    func didFailToFetchCharactersWithError(_ error: Error)
}

class CharactersViewModel {
    
    weak var delegate: CharactersViewModelDelegate?
    
    private var characters: [Person] = []
    private var fetchedCharacterNames: Set<String> = []
    private var currentPage: Int = 1
    private let apiCaller: APICallerProtocol
    private let coreDataStack = CoreDataStack.shared
    private var isFetchingData = false
    
    // Network monitor to observe network connectivity changes
    private var monitor = NWPathMonitor()
    
    init(apiCaller: APICallerProtocol = APICaller.shared) {
        self.apiCaller = apiCaller
        setupNetworkMonitor()
    }
    
    private func setupNetworkMonitor() {
        monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            if path.status == .satisfied {
                // If network is available, fetch from API
                self.fetchCharactersFromAPI(page: self.currentPage)
            } else {
                // If network is not available, fetch from Core Data
                self.fetchCharactersFromCoreData()
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func fetchNextPage() {
        if isFetchingData {
            return // If already fetching data, return without starting a new fetch
        }
        
        isFetchingData = true
        setupNetworkMonitor()
    }
    
    private func fetchCharactersFromAPI(page: Int) {
        apiCaller.fetchPeople(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let people):
                var newPeople = [Person]()
                for person in people {
                    if !self.fetchedCharacterNames.contains(person.name) {
                        newPeople.append(person)
                        self.fetchedCharacterNames.insert(person.name)
                    }
                }
                self.savePeopleToCoreData(newPeople) // Call the function to save people to CoreData
                
                self.characters.append(contentsOf: newPeople)
                self.currentPage += 1
                self.delegate?.didFetchCharactersSuccessfully()
                
                self.isFetchingData = false
            case .failure(let error):
                self.delegate?.didFailToFetchCharactersWithError(error)
                self.isFetchingData = false
            }
        }
        
    }
    
    private func savePeopleToCoreData(_ people: [Person]) {
        let fetchRequest: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        
        do {
            let existingPeople = try coreDataStack.viewContext.fetch(fetchRequest)
            let existingPeopleNames = Set(existingPeople.compactMap { $0.name })
            
            // Determine the starting index for new entries
            var currentIndex = existingPeople.count
            
            for person in people {
                if !existingPeopleNames.contains(person.name) {
                    // Only save the person if it doesn't already exist
                    let personEntity = PersonEntity(context: coreDataStack.viewContext)
                    personEntity.name = person.name
                    personEntity.height = person.height
                    personEntity.mass = person.mass
                    personEntity.hair_color = person.hair_color
                    personEntity.skin_color = person.skin_color
                    personEntity.eye_color = person.eye_color
                    personEntity.birth_year = person.birth_year
                    personEntity.gender = person.gender
                    personEntity.orderIndex = Int16(currentIndex) // Maintain the order index
                    currentIndex += 1
                }
            }
            
            coreDataStack.saveContext()
        } catch {
            print("Failed to save people to Core Data: \(error)")
        }
    }
    
    private func createPeople(from coreDataPeople: [PersonEntity]) -> [Person] {
        let sortedPeople = coreDataPeople.sorted { $0.orderIndex < $1.orderIndex }
        return sortedPeople.map { personEntity in
            return Person(
                name: personEntity.name ?? "",
                height: personEntity.height ?? "",
                mass: personEntity.mass ?? "",
                hair_color: personEntity.hair_color ?? "",
                skin_color: personEntity.skin_color ?? "",
                eye_color: personEntity.eye_color ?? "",
                birth_year: personEntity.birth_year ?? "",
                gender: personEntity.gender ?? ""
            )
        }
    }
    
    private func fetchCharactersFromCoreData() {
        let fetchRequest: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        do {
            let coreDataPeople = try coreDataStack.viewContext.fetch(fetchRequest)
            self.characters = createPeople(from: coreDataPeople)
            
            self.fetchedCharacterNames = Set(coreDataPeople.compactMap { $0.name })
            self.delegate?.didFetchCharactersSuccessfully()
            
            self.delegate?.didFailToFetchCharactersWithError(NetworkError.noInternetConnection)
            
        } catch {
            self.delegate?.didFailToFetchCharactersWithError(error)
        }
    }
    
    
    func characterAtIndex(_ index: Int) -> Person {
        return characters[index]
    }
    
    var numOfCharacters: Int {
        return characters.count
    }
    
    var isInternetAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
}
