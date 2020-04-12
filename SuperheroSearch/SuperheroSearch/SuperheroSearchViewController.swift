//
//  SuperheroSearchViewController.swift
//  SuperheroSearch
//
//  Created by Spencer Curtis on 4/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class SuperheroSearchViewController: UIViewController {
    
    let superheroController = SuperheroController()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        superheroController.superheroesFor(searchTerm: "hulk") {
            // The code in here will only run AFTER the completion() has been called in the superheroesFor function.
            
            DispatchQueue.main.async {
                // I have new search results, display them
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

}

extension SuperheroSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superheroController.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperheroCell", for: indexPath)
        let superhero = superheroController.searchResults[indexPath.row]
        cell.textLabel?.text = superhero.name
        cell.detailTextLabel?.text = superhero.occupation
        return cell
    }
    
    
}
