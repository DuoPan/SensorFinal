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

class PasswordController: UIViewController {

    @IBOutlet var labelID: UITextField!
    @IBOutlet var labelPassword: UITextField!
    
    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    var playerList:[Player]?
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
    }
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoMain") {
            let controller = segue.destination as! MainController
            controller.username = self.labelID.text
            saveLastUser()
        }
    }
    
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

}
