//
//  LoginViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 12/07/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var profileImg:UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
   @objc private func didTapRegister(){
       
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
       let nav = UINavigationController(rootViewController: vc)
       vc.title = "Create Account"
       nav.modalPresentationStyle = .popover
       present(nav, animated: true)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
          
        guard let email = emailTxtField.text ,let password = passwordTxtFld.text,
              !email.isEmpty ,!password.isEmpty, password.count>=6 else{
            alertUserLoginError()
            return
        }
        clearTextfields()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password:password ) { authRegister, error in
            guard let result = authRegister,error == nil else{
                print("Error in sign in \(String(describing: error?.localizedDescription))")
                self.alertUserLoginError()
                return
            }
            let user = result.user
            print("Logged in user \(user)")
      
        }
    }
    
  
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops!!!!",
                                      message: "Please Enter all the information to log In",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
  private  func setView(){
       title = "Login"
      view.backgroundColor = .white
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
      passwordTxtFld.delegate = self
      emailTxtField.delegate = self
    }
}


extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField{
            passwordTxtFld.becomeFirstResponder()
        }else if textField == passwordTxtFld{
            loginBtnTapped((Any).self)
        }
        return true
    }
    
    private func clearTextfields(){
        passwordTxtFld.resignFirstResponder()
        emailTxtField.resignFirstResponder()
        passwordTxtFld.text = ""
        emailTxtField.text = ""
    }
}
