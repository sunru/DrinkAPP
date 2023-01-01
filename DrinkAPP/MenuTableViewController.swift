//
//  MenuTableViewController.swift
//  DrinkAPP
//
//  Created by 廖晨如 on 2022/12/31.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menu = [Records]()
    var field: Fields? = nil
    let apiKey = "keyAMZ33ijMSBRPJG"

    @IBSegueAction func display(_ coder: NSCoder) -> OrderViewController? {
        return OrderViewController(coder: coder, field: field)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MenuTableViewCell.self)", for: indexPath) as? MenuTableViewCell else{
                    fatalError("dequeueReusableCell MenuTableViewCell failed")
                }

        cell.drinkUILabel.text = menu[indexPath.row].fields.Name
        cell.descriptionUILabel.text = menu[indexPath.row].fields.description
        //show image from url
        let url = menu[indexPath.row].fields.image[0].url
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data){
                DispatchQueue.main.async {
                    cell.drinkUIImage.image = image
                }
            }
        }.resume()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        field = menu[indexPath.row].fields
        performSegue(withIdentifier: "showOrder", sender: tableView)
            
    }
    
    func fetchData(){
        if let url = URL(string: "https://api.airtable.com/v0/app0lEtYguOBSiDGA/Menu?sort[][field]=createtime"){
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")//key
            request.httpMethod = "GET"//get
        
            URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                if let data{
                    do{
                        let menuData = try decoder.decode(Menu.self, from: data)
                        DispatchQueue.main.async {
                            self.menu = menuData.records
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
                
            }.resume()
            
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
