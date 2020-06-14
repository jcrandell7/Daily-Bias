//
//  SearchBiasTableViewController.swift
//  Daily Bias
//
//  Created by jordan on 6/13/20.
//  Copyright © 2020 Jordan Crandell. All rights reserved.
//

import UIKit

class SearchBiasTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let biases = Bundle.main.decode([Bias].self, from: "cognitiveBiases.json")

    var filteredData: [Bias]!
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filteredData = biases
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BiasCell", for: indexPath)
        let bias = filteredData[indexPath.row]
        cell.textLabel?.text = bias.title
    
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = biases
        }
        for bias in biases {
            if bias.title.lowercased().contains(searchText.lowercased()){
                filteredData.append(bias)
            }
        }
        self.tableView.reloadData()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //reference the specific segue that you want
        if segue.identifier == "ToBiasDefinitionView" {
            //get the index path of the cell that was tapped
            guard let indexPath = tableView.indexPathForSelectedRow,
                //check the destination of the segue
           let destinationVC = segue.destination as? BiasDefinitionViewController else {return}
            //grab bias based on the index path of a table view cell
            let biasToSend = filteredData[indexPath.row]
            //send the quote to the landing pad (after unwrapping
            destinationVC.bias = biasToSend
        }
    }
}
