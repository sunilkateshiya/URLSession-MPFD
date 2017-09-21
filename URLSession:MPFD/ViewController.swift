//
//  ViewController.swift
//  URLSession:MPFD
//
//  Created by Administrator on 9/20/17.
//  Copyright © 2017 zerones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    typealias Parameters = [String: String]

    @IBAction func getRequest(_ sender: Any) {
        guard let url = URL(string: "http://jsonplaceholder.typicode.com/users") else {return}
        var request = URLRequest(url: url)
        let bountry = generateBountry()
        request.setValue("multipart/form-data; bountry-\(bountry)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: nil, media: nil, bountry: bountry)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        let parameters = ["name": "MyTestFile123321",
                          "description": "My Demo test file for MPFD upload"]
        
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testimage"), forKey: "image") else { return }
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBountry()
        request.setValue("multipart/form-data; bountry-\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID eb18d881ad5416f", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media:[mediaImage], bountry: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        

        
    }
    func generateBountry() -> String {
        return "Bountry-\(NSUUID().uuidString)"
    }
    func createDataBody(withParameters params: Parameters?, media: [Media]?, bountry: String) -> Data {
        
        let lineBrack = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for(key, value) in parameters {
                body.append("--\(bountry + lineBrack)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBrack + lineBrack)")
                body.append("\(value + lineBrack)")
                
                
            }
        }
        
        if let media = media {
            for photo in media {
            body.append("--\(bountry + lineBrack)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBrack)")
            body.append("Content-Type: \(photo.mimiType + lineBrack + lineBrack)")
                
            body.append(photo.data)
                body.append(lineBrack)
         }
        }
        
        
        
        return body
    }
    
}
    
    
    
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


