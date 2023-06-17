import Foundation

protocol NetworkServiceProtocol {
    func getMessage(completion: @escaping (Result<[Message], NetworkError>) -> Void)
}

enum NetworkError: Error {
    case incorrectUrl(String)
    case dataTaskError(Error)
    case failureResponse(String)
    case failureDecode(String)
}

class NetworkService: NetworkServiceProtocol {
    private var offset = 0
    private let staticOffset = 20
    
    func getMessage(completion: @escaping (Result<[Message], NetworkError>) -> Void) {
        let urlString = AppConfiguration.api + "\(offset)"
        
        guard let url = URL(string: urlString) else {
            let message = "\(urlString) - incorrected URL"
            completion(.failure(.incorrectUrl(message)))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.dataTaskError(error)))
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                let message = "Failure response! Response code - \(response.statusCode)"
                completion(.failure(.failureResponse(message)))
            }
            
            guard let data = data, let responseData = try? JSONDecoder().decode(Messages.self, from: data) else {
                let message = "Failure decode \(Messages.self) type"
                completion(.failure(.failureDecode(message)))
                return
            }
            
            var finalMessages = [Message]()
            
            responseData.result.forEach { messageTitle in
                let message = Message(title: messageTitle, imageString: AppConfiguration.staticImageUrl)
                finalMessages.append(message)
            }
            
            completion(.success(finalMessages))
            self.offset += self.staticOffset
        }.resume()
    }
}
