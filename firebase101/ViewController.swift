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
    let db = Database.database().reference()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
//        saveBasicTypes()
        saveCustomers()
    }

    func updateLabel(){
        db.child("firstData").observeSingleEvent(of: .value){ snapshot in
            print("--> \(snapshot)")
            let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
}

extension ViewController {
//    func saveBasicTypes(){
//        db.child("int").setValue(3)
//        db.child("double").setValue(3.5)
//        db.child("string").setValue("is this firebase?")
//        db.child("array").setValue(["a","b","c"])
//        db.child("dict").setValue(["id":"anyId", "pw":"anyPw"])
//    }
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

struct Customer{
    let id:String
    let name:String
    let books:[Book]
    
    var customerToDict:[String:Any]{
        let booksArray = books.map{$0.bookToDict}
        let dict:[String:Any] = ["id": id, "name":name, "books":booksArray]
        return dict
    }
    static var id:Int=0
}

struct Book{
    let title:String
    let author:String
    
    var bookToDict:[String:Any]{
        let dict:[String:Any] = ["title":title, "author":author]
        return dict
    }
}
