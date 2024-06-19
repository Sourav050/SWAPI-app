import CoreData

// Class responsible for managing the Core Data stack
class CoreDataStack {
    // Singleton instance of CoreDataStack
    static let shared = CoreDataStack()
    private init() {
        
    }
    // look into different
    
    // Lazy initialization of the NSPersistentContainer
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWarModel") // Initialize persistent container with the localized data model name
        let storeDescription = NSPersistentStoreDescription(url: self.storeURL) // Create persistent store description
        storeDescription.shouldAddStoreAsynchronously = false // Ensure synchronous loading of stores
        container.persistentStoreDescriptions = [storeDescription] // Assign the store description to the container
        
        // Load persistent stores synchronously
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //Get the URL of the SQLite store
    private var storeURL: URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to get document directory URL")
        }
        return url.appendingPathComponent("StarWarModel.sqlite")
    }
    
    // Computed property to get the view context of the persistent container
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Function to save changes to the view context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
