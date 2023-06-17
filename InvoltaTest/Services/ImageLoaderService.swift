import Foundation

class ImageLoaderService {
    static var requests = [Int: URLRequest]()
    static var imageCache = NSCache<NSString, NSData>()
}
