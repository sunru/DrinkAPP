//
//  OrderTableViewController.swift
//  DrinkAPP
//
//  Created by 廖晨如 on 2023/1/1.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var orders = [Order.Records]()
    var deleteID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.rowHeight = 200
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as? OrderTableViewCell else{
                    fatalError("dequeueReusableCell OrderTableViewCell failed")
                }

        cell.drinkNameLabel.text = orders[indexPath.row].fields.drink
        cell.nameLabel.text = "訂購人: \(orders[indexPath.row].fields.name)"
        cell.iceLabel.text = "冰塊: \(orders[indexPath.row].fields.ice)"
        cell.sugarLabel.text = "甜度: \(orders[indexPath.row].fields.sugar)"
        cell.sizeLabel.text = "大小: \(orders[indexPath.row].fields.size)"
        cell.toppingLabel.text = "\(orders[indexPath.row].fields.toppings)"
        cell.totalCostLabel.text = "$ \(orders[indexPath.row].fields.price)"
        //show image from url
        let url = orders[indexPath.row].fields.imageURL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data){
                DispatchQueue.main.async {
                    cell.drinkImageView.image = image
                }
            }
        }.resume()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteID = orders[indexPath.row].id!
        orders.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        deleteOrder()
    }
    
    func fetchData(){
        if let url = URL(string: "https://api.airtable.com/v0/app0lEtYguOBSiDGA/Order?sort[][field]=createTime"){
            
            var request = URLRequest(url: url)
            request.setValue("Bearer keyAMZ33ijMSBRPJG", forHTTPHeaderField: "Authorization")//key
            request.httpMethod = "GET"//get
        
            URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                if let data{
                    do{
                        let orderData = try decoder.decode(Order.self, from: data)
                        DispatchQueue.main.async {
                            self.orders = orderData.records
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
                
            }.resume()
            
        }
        
    }
    //刪除資料
    func deleteOrder() {
        let url = URL(string: "https://api.airtable.com/v0/app0lEtYguOBSiDGA/Order/\(deleteID)")!
        var request = URLRequest(url: url)
        
        // 刪除該筆資料，httpMethod為DELETE
        request.setValue("Bearer keyAMZ33ijMSBRPJG", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let confirmOrder = orders
        request.httpBody = try? encoder.encode(confirmOrder)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let order = try decoder.decode(Order.self, from: data)
                    print(order)
                }catch{
                    print(error)
                }
            }
        }.resume()
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
