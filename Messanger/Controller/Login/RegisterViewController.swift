//
//  RegisterViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 12/07/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseAnalytics

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailFld: UITextField!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameFld: UITextField!
    @IBOutlet weak var passwordField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAndDelegates()
    }
  
    @IBAction func registerBtnTapped(_ sender: Any) {
      
        guard
            let email = emailFld.text, !email.isEmpty,
              let name = nameFld.text, !name.isEmpty,
              let password = passwordField.text, !password.isEmpty else{
            //let alert = AlertView.shared.showAlertBox(title: "Alert!!", message: "No Field should be empty")
            alertUserRegisterError("No Field should be empty")
            return
        }
        if password.count<6{
            alertUserRegisterError("Password should Be atleast 6 characters!!!!")
            return
        }
        firebaseLogin(email: email, password: password,name:name)
    }
  
     
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        presentPhotoActionSheet()
   }
    
     private func alertUserRegisterError(_ message:String){
        let alert = UIAlertController(title: "Woops!!!!",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }

   private func clearTextfields(){
        nameFld.resignFirstResponder()
        emailFld.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameFld.text = ""
        emailFld.text = ""
        passwordField.text = ""
    }
    private func setViewAndDelegates(){
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(didTapBack))
        title = "Register"
        view.backgroundColor = .white
        nameFld.delegate = self
        emailFld.delegate = self
        passwordField.delegate = self
    }
    
    @objc private func didTapBack(){
        self.dismiss(animated: true)
     }
    
    @IBAction func clickOnGoogleSignIn(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              alertUserRegisterError("Error in Google Sign In")
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              alertUserRegisterError("Error in Google Sign In")
           return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                print("Created user \(String(describing: user))")
                self.dismiss(animated: true)
            }
                
        }
    }
    
    
    // firebase LogIn

    private func firebaseLogin(email:String,password:String,name:String){
        
        DataBaseManager.shared.validateNewUser(with: email) { exists in
            guard !exists else{
                print("User already Exists!!!!")
                self.alertUserRegisterError("User already Exists!!!!")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail:email , password: password) { [weak self] authResult,error in
                            guard let strongSelf = self else{
                                return
                            }
                guard let result = authResult,
                      error == nil else{
                    print("Error in registering")
                    self?.alertUserRegisterError("Error in Registering!!")
                    return
                }
                DataBaseManager.shared.insertUser(with: ChatAppUser(emailAddress: email, name: name))
                let user = result.user
                print("Created user \(String(describing: user))")
                self?.firebaseSignIn(email: email, password: password)
            }
            
        }
    }
    
    
    private func firebaseSignIn(email:String,password:String){
             
             FirebaseAuth.Auth.auth().signIn(withEmail: email, password:password ) { [weak self] authRegister, error in
                 guard let strongSelf = self else{
                     return
                 }
                 guard let result = authRegister,error == nil else{
                     print("Error in sign in \(String(describing: error?.localizedDescription))")
                     self?.alertUserRegisterError("No Field should be empty")
                     return
                 }
                 let user = result.user
                 print("Logged in user \(user)")
                 strongSelf.dismiss(animated: true)
             }
         }
         

    
    
    
    
    
    
}
    
    
// MARK: UIImagePicker extension

extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func presentPhotoActionSheet(){
        let actionsheet = UIAlertController(title: "Profile Picture", message: "HOw would you like to take Picture", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Take Photo", style: .default,
                                            handler: { [weak self] _ in
                                            self?.presentCamera()
        }))
        actionsheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,
                                            handler: { [weak self] _ in
                                            self?.presentGallery()
        }))
        present(actionsheet, animated: true)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
             profileImg.image = pickedImage
           
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Handle the user canceling the image picker, if needed.
        dismiss(animated: true, completion: nil)
    }
    func presentCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera// for capturing photos
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func presentGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}
// MARK: Textfield extension

extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameFld{
            emailFld.becomeFirstResponder()
        }else
        if textField == emailFld{
            passwordField.becomeFirstResponder()
        }else
        if textField == passwordField{
            registerBtnTapped((Any).self)
        }
        return true
    }
    
    
}
