//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        
        let secret = Secret()
        
        let urlString = "https://api.github.com/repositories?client_id=\(secret.clientID)&client_secret=\(secret.clientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion:(Bool) -> ()) {
        
        
        let secret = Secret()
        
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let nsURLToSend = NSURL.init(string: urlString)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest()
        request.HTTPMethod = "GET"
        request.addValue("token \(secret.accessToken)", forHTTPHeaderField: "Authorization")
        request.URL = nsURLToSend
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            let nResponse = response as! NSHTTPURLResponse
            
            print("check method found \(response)")
            
            if nResponse.statusCode == 204 {
                
                completion(true)
                
            } else if nResponse.statusCode == 404 {
                
                completion(false)
            }
            
        }
        
        task.resume()
    }
    
    class func starRepository(fullName: String, completion:() -> ()) {
        
        let secret = Secret()
        
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let nsURLToSend = NSURL.init(string: urlString)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest()
        request.HTTPMethod = "PUT"
        request.addValue("token \(secret.accessToken)", forHTTPHeaderField: "Authorization")
        request.URL = nsURLToSend
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            let response = response as! NSHTTPURLResponse
            
            print("star method found \(response)")
            
            if response.statusCode == 204 {
                
                completion()
                
            }
            
        }
        
        task.resume()
    }
    
    class func unstarRepository(fullName: String, completion:() -> ()) {
        
        let secret = Secret()
        
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let nsURLToSend = NSURL.init(string: urlString)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest()
        request.HTTPMethod = "DELETE"
        request.addValue("token \(secret.accessToken)", forHTTPHeaderField: "Authorization")
        request.URL = nsURLToSend
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            let response = response as! NSHTTPURLResponse
            
            print("unstar method found \(response)")
            
            if response.statusCode == 204 {
                
                completion()
                
            }
            
        }
        
        task.resume()
    }
}

