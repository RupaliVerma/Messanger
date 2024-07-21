//
//  ProfileViewController.swift
//  Messanger
//
//  Created by RUPALI VERMA on 12/07/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTblView: UITableView!
    let cellItems:[String] = ["LogOut"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    private func setView(){
        profileTblView.delegate = self
        profileTblView.dataSource = self
        view.backgroundColor = .yellow
        self.title = "Profile"
    }

}



extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:  indexPath)
        cell.textLabel?.text = cellItems[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            guard let stongSelf = self else {
                return
            }
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                self?.dismiss(animated: true)
                
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            
    //            let vc = LoginViewController()
    //            let nav = UINavigationController(rootViewController: vc)
    //            nav.present(nav, animated: true)
    //
            } catch let error {
                print("failed to logOut\(error.localizedDescription)")
            }

        }))
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    
}
