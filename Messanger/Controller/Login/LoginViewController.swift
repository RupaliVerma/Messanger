//
//  LoginViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 12/07/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var profileImg:UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validatAuth()
    }
    
   @objc private func didTapRegister(){
       
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
       let nav = UINavigationController(rootViewController: vc)
       vc.title = "Create Account"
       nav.modalPresentationStyle = .fullScreen
       present(nav, animated: true)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTxtField.text ,let password = passwordTxtFld.text,
              !email.isEmpty ,!password.isEmpty, password.count>=6 else{
            alertUserLoginError()
            return
        }
        clearTextfields()
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password:password ) { [weak self] authRegister, error in
            guard let strongSelf = self else{
                return
            }
            guard let result = authRegister,error == nil else{
                print("Error in sign in \(String(describing: error?.localizedDescription))")
                self?.alertUserLoginError()
                return
            }
            let user = result.user
            print("Logged in user \(user)")
           
            strongSelf.dismiss(animated: true)
        }
    }
    
    @IBAction func clickOnGoogleSignIn(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          // ...
        }
    }
    
    
  
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops!!!!",
                                      message: "Please Enter all the information to log In",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
  private  func setView(){
       title = "Login"
      view.backgroundColor = .white
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
      passwordTxtFld.delegate = self
      emailTxtField.delegate = self
    }
    
    private func validatAuth(){
        if FirebaseAuth.Auth.auth().currentUser != nil{
            self.dismiss(animated: false)
        }
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
