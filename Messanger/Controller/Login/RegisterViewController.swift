//
//  RegisterViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 12/07/24.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailFld: UITextField!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameFld: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .white
          ()
    }
  
    @IBAction func registerBtnTapped(_ sender: Any) {
        clearTextfields()
        self.dismiss(animated: true)
    }
    
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        presentImagePicker()
   }
}

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
    
    
   private func clearTextfields(){
        nameFld.resignFirstResponder()
        emailFld.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameFld.text = ""
        emailFld.text = ""
        passwordField.text = ""
    }
    private func delegates(){
        nameFld.delegate = self
        emailFld.delegate = self
        passwordField.delegate = self
    }
    private func presentImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Or .camera for capturing photos
        present(imagePicker, animated: true, completion: nil)
    }
}

extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let pickedImage = info[.originalImage] as? UIImage {
            // You now have the selected or captured image (pickedImage).
            // You can use it as needed within your app.
             profileImg.image = pickedImage
             profileImg.backgroundColor = .darkGray
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Handle the user canceling the image picker, if needed.
        dismiss(animated: true, completion: nil)
    }
    
}
