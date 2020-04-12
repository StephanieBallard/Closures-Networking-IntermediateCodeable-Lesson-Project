//
//  SuperheroController.swift
//  SuperheroSearch
//
//  Created by Stephanie Ballard on 4/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class SuperheroController {
    
    var searchResults: [Superhero] = []
    var baseURL: URL = URL(string: "https://superheroapi.com/api/10100896649479593/")!
    
    // I want this function to take in a search term and give me back the results of the search as a [Superhero]
    func superheroesFor(searchTerm: String, completion: @escaping () -> Void) {
        // Set up the URL, if you have query parameters (also called query items) you should probably use URLComponents to format your URL
        let requestURL = baseURL
            .appendingPathComponent("search")
            .appendingPathComponent(searchTerm)
        // Create a URL request... 99% of the time this will be a variable because you will be making changes to it
        let request = URLRequest(url: requestURL)
        // If necessary, add body, add headers, change the HTTP Method, add authorization to the request
        
        // Perform the request
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Anything put in this closure will run AFTER the request has gone to the server, and come back with some information from the server
            // Check for errors
            if let error = error {
                NSLog("Error searching for superheroes: \(error)")
            }
            
            // Check the status code of the response
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Error: status code is not 200. Instead it is \(response.statusCode)")
            }
            
            // Check for data
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let superheroeSearch = try decoder.decode(SuperheroSearch.self, from: data)
                self.searchResults = superheroeSearch.results
                
            } catch {
                NSLog("Error decoding SuperheroSearch: \(error)")
            }
            completion()
        }
        
        dataTask.resume()
        
    }
}
