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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAndDelegates()
    }
  
    @IBAction func registerBtnTapped(_ sender: Any) {
        clearTextfields()
        self.dismiss(animated: true)
    }
    
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        presentPhotoActionSheet()
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
    private func setViewAndDelegates(){
        title = "Register"
        view.backgroundColor = .white
        nameFld.delegate = self
        emailFld.delegate = self
        passwordField.delegate = self
    }
    
}

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
