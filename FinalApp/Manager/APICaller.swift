import Foundation

// MARK: - Constants

struct Constants {
    static let baseURL = "https://swapi.dev/api/"
}

// MARK: - API Error

enum APIError: Error {
    case failedTogetData
}

// MARK: - APICaller

class APICaller : APICallerProtocol {
    // Singleton instance
    static let shared = APICaller()
    
    
    private init() {
        
    }
    
    // Fetch people from API
    func fetchPeople(page: Int, completion: @escaping (Result<[Person], Error>) -> Void) {
        // Construct URL with page parameter
        guard let url = URL(string: "\(Constants.baseURL)people?page=\(page)") else {
            return
        }
        
        // Create URLSessionDataTask for API call
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedTogetData))
                return
            }
            
            do {
                // Decode JSON response
                let results = try JSONDecoder().decode(PersonResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume() 
    }
}
