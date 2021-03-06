//
//  ViewController.swift
//  ios-network
//
//  Created by Rachit Mishra on 21/11/18.
//  Copyright © 2018 ceeq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var work: DispatchWorkItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchAndLoadImage()
    }
    
    
    /**
     NSURLSession
     ->
     NSURLSessionTask
     ->
     NSURLSessionDataTask -> into memory as NSData
     NSURLSessionDownloadTask -> into file
     NSURLSessionUploadTask -> helps in uploading
     **/
    
    @IBAction
    func fetchAndLoadImage() {
        
       
        
        fetchAndLoad2(url: buildUrl1())
    }
    
    private func buildUrl1() -> URL {
        let baseApi = "https://api.unsplash.com"
        let path = "/photos/random"
        
        let paramString = escapedParams(for: ["client_id" : "3b9ef3b68a4dbbe28ed6edc2d150904a4a143a09a083396a46e2dc9a0f6eca66"])
        
        // Image url
        let imageUrl: URL = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        return imageUrl
    }
    
    private func buildUrl2() -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.unsplash.com"
        urlComponent.path = "/photos/random"
        urlComponent.queryItems = [URLQueryItem]()
        urlComponent.queryItems?.append(URLQueryItem(name: "client_id", value:
        "3b9ef3b68a4dbbe28ed6edc2d150904a4a143a09a083396a46e2dc9a0f6eca66"))
        
        return urlComponent.url!
    }
    
    private func fetchAndLoad1(url: URL) {
     
        let queue = DispatchQueue.global()
        // URLSession request
        let work = DispatchWorkItem {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let imageData = data {
                    
                    // Run on main
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage.init(data: imageData)
                    }
                }
            }
            task.resume()
        }
        queue.async(execute: work)
        
    }
    
    struct ImageResponse: Codable {
        let url:ImageResponseUrl
        
        enum CodingKeys: String, CodingKey {
            case url = "urls"
        }
    }
    
    struct ImageResponseUrl: Codable {
        let raw: String
    }
    
    struct DogApi: Codable {
        let status:String
        let message:String
    }
    
    private func fetchAndLoad2(url: URL) {
        let request = URLRequest(url: url)
        
        let queue = DispatchQueue.global()
        // URLSession request
        
        work?.cancel()
        
        work = DispatchWorkItem {

        // URLSession request
            let task = URLSession.shared.dataTask(with: request){
                
                (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                let decoder = JSONDecoder()
                var parsedUrl: String = ""
                do {
                    parsedUrl = try decoder.decode(DogApi.self, from: data).message
                } catch {
                    print("Failed to parse JSON")
                }
                
                // Run on main
                DispatchQueue.main.async {
                    let imageData = try! Data(contentsOf: URL(string: parsedUrl)!)
                        self.imageView.image = UIImage.init(data: imageData)
                }
            }
            
            task.resume()
        }
                
        queue.async(execute: work)
        
    }
    
    
    func escapedParams(for params: [String: Any]) -> String  {
        
        guard !params.isEmpty else {
            return "Empty params"
        }
        
        var keyValuePairs = [String]()
        
        for (key, value) in params {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            keyValuePairs.append("\(key)=\(escapedValue!)")
        }
        
        return "?\(keyValuePairs.joined(separator: "&"))"
    }


}

