//
//  OrderViewController.swift
//  DrinkAPP
//
//  Created by 廖晨如 on 2023/1/1.
//

import UIKit

class OrderViewController: UIViewController {
    
    
    @IBOutlet weak var orderDrinkImageView: UIImageView!
    @IBOutlet weak var orderDrinkLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sweetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var temperSegmentedControl: UISegmentedControl!
    @IBOutlet weak var volumeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var toppingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var costLebal: UILabel!
    
    var name = String()
    var size = String()
    var sugar =  String()
    var ice = String()
    var toppings = String()
    //viewDidLoad 可得
    var drink = String()
    var imageURL = URL(string: String())
    var priceM = Int()
    var priceL = Int()
    var totalPrice = Int()
    
    
    //接收上一頁 IBSegueAction 傳過來的Info
    var field: Fields? = nil
    init?(coder: NSCoder, field: Fields?) {
        self.field = field
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let field = field{
            //show drink name
            drink = field.Name
            orderDrinkLabel.text = drink
            //show image from url
            imageURL = field.image[0].url
            let url = field.image[0].url
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.orderDrinkImageView.image = image
                    }
                }
            }.resume()
            //show cost
            priceM = field.medium
            priceL = field.large
            total()
            
        }
        // Do any additional setup after loading the view.
    }
    
    //計算金額
    func total() {
        if volumeSegmentedControl.selectedSegmentIndex == 0 {
            totalPrice = priceM
        } else {
            totalPrice = priceL
        }
        if toppingSegmentedControl.selectedSegmentIndex != 0 {
            totalPrice += 10
            costLebal.text = "$ \(totalPrice)"
        } else {
            costLebal.text = "$ \(totalPrice)"
        }
    }
    
    
    @IBAction func calculateCost(_ sender: UISegmentedControl) {
        total()
    }
    
    // 送出
    @IBAction func order(_ sender: Any) {
        name = nameTextField.text!
        size = volumeSegmentedControl.titleForSegment(at: volumeSegmentedControl.selectedSegmentIndex)!
        sugar = sweetSegmentedControl.titleForSegment(at: sweetSegmentedControl.selectedSegmentIndex)!
        ice = temperSegmentedControl.titleForSegment(at: temperSegmentedControl.selectedSegmentIndex)!
        toppings = toppingSegmentedControl.titleForSegment(at: toppingSegmentedControl.selectedSegmentIndex)!
        
        if name == "" {
            let controller = UIAlertController(title: "請輸入姓名", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } else {

            if let imageURL{
                let controller = UIAlertController(title: "訂購成功", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default) { action in
                    self.uploadOrder(image: imageURL)
                }
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }else{
                let controller = UIAlertController(title: "沒有圖片", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default)
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            }
                


        }
    }
    
    //上傳資料
    func uploadOrder(image: URL){
        
        if let url = URL(string: "https://api.airtable.com/v0/app0lEtYguOBSiDGA/Order"){
            var request = URLRequest(url: url)
            
            request.setValue("Bearer keyAMZ33ijMSBRPJG", forHTTPHeaderField: "Authorization")//key
            request.httpMethod = "POST"//post
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let encoder = JSONEncoder()
            let confirmOrder = Order(records: [.init(fields: .init(name: name, drink: drink, size: size, sugar: sugar, ice: ice, toppings: toppings, price: totalPrice, imageURL: image))])
            
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
        
    }
}
