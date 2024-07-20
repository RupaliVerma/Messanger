//
//  HelperViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 20/07/24.
//

import UIKit

class HelperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
}


struct AlertView {
  // Shared instance
 static let shared: AlertView = AlertView()

// Private initializer to prevent creating of new instances
          private init() {}
          public func showAlertBox(title: String, message: String) -> UIAlertController {
              let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
              }))
              return alert
          }
}
      
  
