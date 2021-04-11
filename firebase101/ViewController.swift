//
//  ViewController.swift
//  firebase101
//
//  Created by YOONJONG on 2021/04/06.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numOfLabel: UILabel!
    
    let db = Database.database().reference()
    var customers:[Customer]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveCustomers()
        fetchCustomers()
//        saveBasicTypes()
//        updateBasicTypes()
//        deleteBasicTypes()
    }
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    @IBAction func fetchCustomer(_ sender: Any) {
        fetchCustomers()
    }
    
    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomers()
    }
    @IBAction func deleteCustomer(_ sender: Any) {
        deleteCustomers()
    }
    
    
}

extension ViewController {
    
    
    func saveCustomers(){  
        let book1 = [Book(title: "harry porter", author: "j.k rolling"), Book(title: "alice", author: "lee")]
        let customer1 = Customer(id: "\(Customer.id)", name: "Steve", books: book1)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "Jobs", books: book1)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "Paul", books: book1)
        
        db.child("customers").child(customer1.id).setValue(customer1.customerToDict)
        db.child("customers").child(customer2.id).setValue(customer2.customerToDict)
        db.child("customers").child(customer3.id).setValue(customer3.customerToDict)
    }
}
extension ViewController{
    func fetchCustomers(){
        db.child("customers").observeSingleEvent(of: .value) { (snapshot) in
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let customers:[Customer] = try decoder.decode([Customer].self, from: data)
                self.customers = customers
                print("--> \(customers.count)")
                DispatchQueue.main.async {
                    self.numOfLabel.text = "# of Customers : \(customers.count)"
                }
            }
            catch let error {
                print("--> error : \(error.localizedDescription)")
            }
        }
    }
    func updateCustomers(){
        guard customers.isEmpty == false else{return}
        customers[0].name = "Min"
        let dictionary = customers.map{$0.customerToDict}
        db.updateChildValues(["customers":dictionary])
        
    }
    func deleteCustomers(){
        db.child("customers").removeValue()
        
    }
}

//extension ViewController{
//    func saveBasicTypes(){
//        db.child("int").setValue(1)
//        db.child("double").setValue(1.1)
//        db.child("str").setValue("내용")
//    }
//    func updateBasicTypes(){
//        db.child("int").setValue(3000)
//        db.child("double").setValue(30.123)
//        db.child("str").setValue("수정된 내용")
//    }
//    func deleteBasicTypes(){
//        db.child("int").removeValue()
//    }
//}

struct Customer:Codable{
    let id:String
    var name:String
    let books:[Book]
    
    var customerToDict:[String:Any]{
        let booksArray = books.map{$0.bookToDict}
        let dict:[String:Any] = ["id": id, "name":name, "books":booksArray]
        return dict
    }
    static var id:Int=0
}

struct Book:Codable{
    let title:String
    let author:String
    
    var bookToDict:[String:Any]{
        let dict:[String:Any] = ["title":title, "author":author]
        return dict
    }
}
