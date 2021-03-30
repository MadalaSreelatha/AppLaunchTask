//
//  SignUpViewController.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 22/03/21.
//

import UIKit
import SQLite3

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var signUpScreenScrollView : UIScrollView!
    @IBOutlet weak var firstNameTextField : UITextField!
    @IBOutlet weak var lastNameTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var genderTextField : UITextField!
    @IBOutlet weak var confirmPasswordTextField : UITextField!
    @IBOutlet weak var signUpBtn : UIButton!
    @IBOutlet weak var termsBtn : UIButton!
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var logoImg : UIImageView!
    @IBOutlet weak var signUpLbl : UILabel!
    @IBOutlet weak var termsLbl : UILabel!
    
    var themes : Themes = Themes()
    var unchecked = true
    var db: OpaquePointer?
    var usersList = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.setBottomBorder()
        self.lastNameTextField.setBottomBorder()
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
        self.genderTextField.setBottomBorder()
        self.confirmPasswordTextField.setBottomBorder()
        
        // Creation
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("SignUpDetailsDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS SignUpDetails (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, lastname TEXT, email TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "App Launch", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //#MARK: UIBUTTON ACTIONS
    @IBAction func onClickSignUp() {
        let validatePassword = themes.isPasswordValid(passwordTextField.text!)
        let validateEmailId = themes.isValidEmail(emailAddressString: emailTextField.text!)
        guard !(firstNameTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Firstname")
            return
        }
        guard !(lastNameTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Lastname")
            return
        }
        guard !(emailTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Email address")
            return
        }
        guard validateEmailId else {
            self.showAlert(message: "Please enter your valid Email address")
            return
        }
        guard !(passwordTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Password")
            return
        }
        guard !(confirmPasswordTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Confirm Password")
            return
        }
        guard (passwordTextField.text!.caseInsensitiveCompare(confirmPasswordTextField.text!) == ComparisonResult.orderedSame) else {
            self.showAlert(message: "Password and Confirm password not matched")
            return
        }
        
        if !(firstNameTextField.text!.isEmpty) && !(lastNameTextField.text!.isEmpty) && !(emailTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty) && validateEmailId == true && !(confirmPasswordTextField.text!.isEmpty) && (passwordTextField.text!.caseInsensitiveCompare(confirmPasswordTextField.text!) == ComparisonResult.orderedSame) {
            
            //Insert Table
            let firstname = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO SignUpDetails (firstname, lastname, email) VALUES (?,?,?)"
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            if sqlite3_bind_text(stmt, 1, firstname, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding firstname: \(errmsg)")
                return
            }
            if sqlite3_bind_text(stmt, 2, lastname, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding lastname: \(errmsg)")
                return
            }
            if sqlite3_bind_text(stmt, 3, email, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding email: \(errmsg)")
                return
            }
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting SignUpDetails: \(errmsg)")
                return
            }
            print("SignUpDetails saved successfully")
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        }
    }
    @IBAction func onClickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickCheck(sender: UIButton) {
        if unchecked {
            sender.setImage(UIImage(named:"blank-check-box"), for: .normal)
            unchecked = false
        } else {
            sender.setImage(UIImage(named:"checkbox"), for: .normal)
            unchecked = true
        }
    }
}
