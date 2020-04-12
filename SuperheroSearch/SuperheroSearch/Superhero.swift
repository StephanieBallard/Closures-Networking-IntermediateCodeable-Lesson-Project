//
//  Superhero.swift
//  SuperheroSearch
//
//  Created by Stephanie Ballard on 4/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct SuperheroSearch: Decodable {
    let results: [Superhero]
}

struct Superhero: Decodable {
    // What information is relevant to our app?
    let name: String
    let occupation: String
    let height: Int
    var imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case appearance
        case work
        case image
    }
    
    enum WorkCodingKeys: String, CodingKey {
        case occupation
    }
    
    enum AppearanceCodingKeys: String, CodingKey {
        case height
    }
    
    enum ImageCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        // Get the container (in the correct format) to represent the WHOLE JSON.
        // In this case, it will be a dictionary, or a KeyedDecodingContainer
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Name
        // now that we are going through the levels we dont use decoder we are using the container
        self.name = try container.decode(String.self, forKey: .name)
        
        // Occupation
        let workContainer = try container.nestedContainer(keyedBy: WorkCodingKeys.self, forKey: .work)
        
        self.occupation = try workContainer.decode(String.self, forKey: .occupation)
        
        // Height
        // heigh doesn't live in the work container at all, it lives in the bigger container where appearance is so we need to go back to the main container to access appearance
        let appearanceContainer = try container.nestedContainer(keyedBy: AppearanceCodingKeys.self, forKey: .appearance)
        
        // unkeyed so we don't need to make a set of coding keys for it
        var heightContainer = try appearanceContainer.nestedUnkeyedContainer(forKey: .height)
        
        // As long as there is something to be decoded from the array keep looping
        var heights: [String] = []
        
        while !heightContainer.isAtEnd {
            let height = try heightContainer.decode(String.self)
            heights.append(height)
        }
        
        // CHOOSE ONE, Don't keep both
        
        //        for _ in 0..<(heightContainer.count ?? 0) {
        //            let height = try heightContainer.decode(String.self)
        //            heights.append(height)
        //        }
        //      "244 cm"    //We are unwrapping three things in an if let statement
        if let heightsInCm = heights.last,
            let heightString = heightsInCm.components(separatedBy: " ").first, //if it isn't .first you would do [2]
            let height = Int(heightString) {
            self.height = height // 244
            
        } else {
            self.height = -1
        }
        // parsing strings - pulling parts of a string out
        
        // will give us an array of ["244", "cm"] the code below is taking everything in the string that is seperated by a string and turning it into an array so we can use each part of the srtring individually
        //let heightString = heightsInCm.components(separatedBy: " ").first  - moved above to add it to the if let statement to unwrap them both at the same time
        
        // Image
        
        let imageContainer = try container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        
        // handling optional because we are working with json, someone else's code, we dont know that the api is set up the way we expect, this will handle that, maybe it isn't in the exact format that we expect it to be in
        if let imageString = try imageContainer.decodeIfPresent(String.self, forKey: .url) {
            self.imageURL = URL(string: imageString)
        }
    }
}




