//
//  ImageDownloader.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import Foundation
import UIKit.UIImage


class ImageDownloader {
    private init() {
        let cache  = NSCache<NSNumber, UIImage>()
        cache.countLimit = kCacheSize
        cache.name = "ImageDownloaderCache"
        self.cache = cache
    }
    
    static let shared = ImageDownloader()
    let kBaseURL = "http://lorempixel.com.br"
    
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = ProcessInfo.processInfo.processorCount
        queue.underlyingQueue = DispatchQueue.global(qos: .userInteractive)
        return queue
    }()
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.isDiscretionary = true
        configuration.networkServiceType = .responsiveData
        configuration.multipathServiceType = .interactive
        
    
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: operationQueue)
        session.sessionDescription = "ImageDownloaderURLSession"
        return session
    }
    
    private let kCacheSize = 80
    
    private var cacheKeys = Set<NSNumber>()
    private var cache: NSCache<NSNumber, UIImage>
    
    
    func beginCachingImages() {
        var operations = [BlockOperation]()
        for i in 0...kCacheSize {
             let bo = BlockOperation {
                if let url = URL(string: "\(self.kBaseURL)/1900/1900/?\(i)") {
                    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 300)
                    
                    let task = self.session.dataTask(with: request) { (data, response, error) in
                        if let imageData = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            if let image = UIImage(data: imageData) {
                                let key = NSNumber(integerLiteral: imageData.hashValue)
                                let (didInsert, _) = self.cacheKeys.insert(key)
                                if didInsert {
                                    self.cache.setObject(image, forKey: key)
                                }
                            }
                        }
                        if error != nil {
                            debugPrint(error!)
                        }
                    }
                    task.resume()
                }
            }
            operations.append(bo)
        }
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func randomImage() -> UIImage {
        if cacheKeys.count > 0 {
            let random = arc4random() % UInt32(cacheKeys.count)
            let index = cacheKeys.index(cacheKeys.startIndex, offsetBy: Int(random))
            let key = cacheKeys[index]
            if let image = cache.object(forKey: key) {
                return image
            }
        }
        
        return UIImage(named: "placeholder-image")!
    }

    
}
