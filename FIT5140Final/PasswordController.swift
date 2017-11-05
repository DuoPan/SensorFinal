//
//  PasswordController.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase
import CoreData

//This is the login page

class PasswordController: UIViewController {

    @IBOutlet var labelID: UITextField!         //login name
    @IBOutlet var labelPassword: UITextField!   //login password
    
    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    var playerList:[Player]?                    //store all players name/password pair
    
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToPrevious))
        self.view.backgroundColor =  UIColor(patternImage: #imageLiteral(resourceName: "loginbg"))
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        fetchLastLogin()
        
        playerList = [Player]()
        download()
    }

    // get all players' login information from firebase, sotre in the list
    func download()
    {
        firebaseRef = Database.database().reference(withPath:"Players")
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            self.playerList?.removeAll()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: AnyObject]
                let player = Player()
                player.name = dict["name"] as! String
                player.password = dict["password"] as! String
                self.playerList?.append(player)
            }
        })
    }
    
    // remove observer
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    
    // pop up dialog to give user feedback
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // called by nav bar left button
    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
    }
    
    // user login info validation
    @IBAction func login(_ sender: Any) {
        if labelID.text == "" || labelPassword.text == "" {
            showMessage(msg: "Please Enter Name and Password")
            return
        }
        for p in self.playerList!{
            if p.name == labelID.text && p.password == labelPassword.text{
                // success
                self.performSegue(withIdentifier: "gotoMain", sender: view)
                return
            }
        }
        // wrong pair
        showMessage(msg: "Wrong Name or Password")
        return
    }
    
    // app remember the last login user info from coredata
    // it is for quick login
    func fetchLastLogin()
    {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let user = try managedContext?.fetch(userFetch) as? [User]
            if(user?.count == 0){
                return
            }
            labelID.text = user?[0].name
            labelPassword.text = user?[0].password
        } catch {
            fatalError("Failed to fetch category list: \(error)")
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoMain") {
            let controller = segue.destination as! MainController
            controller.username = self.labelID.text
            saveLastUser()
        }
    }
    
    // after login, coredata will store the current login user info.
    func saveLastUser()
    {
        let lastFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var lastUser : [User]?
        do {
            lastUser = try managedContext?.fetch(lastFetch) as? [User]
            if(lastUser?.count == 0)
            {
                // save new into core data
                let u = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext!) as! User
                u.name = labelID.text
                u.password = labelPassword.text
            }else{// update category into core data
                lastUser?[0].name = labelID.text
                lastUser?[0].password = labelPassword.text
            }
        } catch {
            fatalError("Failed to fetch category list: \(error)")
        }
        appDelegate?.saveContext()
    }

    // touch background to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
