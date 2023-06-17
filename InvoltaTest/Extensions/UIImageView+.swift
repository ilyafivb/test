import Foundation
import UIKit

extension UIImageView {
    func startDownload(from urlString: String) {
        let cacheId = urlString as NSString
        if let cacheData = ImageLoaderService.imageCache.object(forKey: cacheId) {
            DispatchQueue.main.async {
                self.image = UIImage(data: cacheData as Data)
                ImageLoaderService.requests.removeValue(forKey: self.hashValue)
            }
        } else {
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            ImageLoaderService.requests[hashValue] = request
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    ImageLoaderService.imageCache.setObject(data as NSData, forKey: cacheId)
                    ImageLoaderService.requests.removeValue(forKey: self.hashValue)
                }
            }.resume()
        }
    }
    
    func stopDownload() {
        ImageLoaderService.requests.removeValue(forKey: hashValue)
    }
}
