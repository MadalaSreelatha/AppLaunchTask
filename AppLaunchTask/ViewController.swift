//
//  ViewController.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 22/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var signInScreenScrollView : UIScrollView!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var signInBtn : UIButton!
    @IBOutlet weak var creatAccountBtn : UIButton!
    @IBOutlet weak var forgotPasswordBtn : UIButton!
    @IBOutlet weak var logoImg : UIImageView!
    
    var themes : Themes = Themes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "App Launch", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //#MARK : UIBUTTON ACTIONS
    @IBAction func onClickSignIn() {
        let validateEmailId = themes.isValidEmail(emailAddressString: emailTextField.text!)
        guard !(emailTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Email address")
            return
        }
        guard validateEmailId else {
            self.showAlert(message: "Please enter your valid email address")
            return
        }
        guard !(passwordTextField.text!.isEmpty) else {
            self.showAlert(message: "Please enter your Password")
            return
        }
        if !(emailTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty) && validateEmailId == true {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        }
    }
    @IBAction func onClickCreateAccount() {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true)
    }
    @IBAction func onClickForgotPassword() {
        
    }
}

