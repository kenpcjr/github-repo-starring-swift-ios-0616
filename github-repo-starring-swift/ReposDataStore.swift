//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatusForRepository(repository: GithubRepository, completion: (starred: Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (isStarred) in
            
            if isStarred == false {
                
                
                GithubAPIClient.starRepository(repository.fullName, completion: { 
                    print("I'm starring it!")
                    completion(starred: true)

                })
                
                
                
            } else if isStarred == true {
                
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    print("NO Stars!")
                    completion(starred: false)
                })
                
            
               
            }
            

        }
        
        
    }

}
