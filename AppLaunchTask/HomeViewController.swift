//
//  HomeViewController.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 23/03/21.
//

import UIKit
import SQLite3

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userDetailsTable : UITableView!
    @IBOutlet weak var titleLbl : UILabel!
    
    var usersList = [UserData]()
    var db: OpaquePointer?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userDetailsTable.delegate = self
        self.userDetailsTable.dataSource = self
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.userDetailsTable.refreshControl = refreshControl
        } else {
            self.userDetailsTable.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        
        
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("SignUpDetailsDatabase.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS SignUpDetails (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, email TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        readValues()
    }
    
    @objc private func refreshListData(_ sender: Any) {
        readValues()
    }
    
    func readValues() {
        usersList.removeAll()
        let queryString = "SELECT * FROM SignUpDetails"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            
            let id = sqlite3_column_int(stmt, 0)
            let firstname = String(cString: sqlite3_column_text(stmt, 1))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            
            usersList.append(UserData(id: Int(id), firstname: firstname, email: email))
        }
        
        self.userDetailsTable.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //MARK: Delete Operation
    func deleteItemFromList(itemId: Int32){
        
        let deleteStatementStirng = "DELETE FROM SignUpDetails WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, itemId)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        print("delete")
    }
    
    //UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let user : UserData
        user = usersList[indexPath.row]
        cell.firstNameLbl.text = "FirstName : \(user.firstname ?? "")"
        cell.emailLbl.text = "Email :" + "\(user.email ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            usersList.remove(at: indexPath.row)
            self.deleteItemFromList(itemId: Int32(usersList[indexPath.row].id))
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=12.9082847623315&lon=77.65197822993314&units=imperial&appid=b143bb707b2ee117e62649b358207d3e")!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }

            guard let data = data else {
                return
            }

            guard let dictionaryObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }

            guard let list = dictionaryObj["list"] as? [[String: Any]] else {

                return
            }

            if let first = list.first, let wind = first["wind"] {
                print(wind)
            }
        }).resume()
    }
}
