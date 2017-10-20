//
//  SignupController.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password1: UITextField!
    @IBOutlet var password2: UITextField!
    
    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    var nameList:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToPrevious))
        
        nameList = [String]()
        download()
    }

    func download()
    {
        firebaseRef = Database.database().reference(withPath:"Players")
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            self.nameList?.removeAll()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: AnyObject]
                let name = dict["name"] as! String
                self.nameList?.append(name)
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    
    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
    }

    @IBAction func create(_ sender: Any) {
        if username.text == "" {
            showMessage(msg: "Please Enter a User Name")
            return
        }
        if (nameList?.contains(username.text!))!{
            showMessage(msg: "The Name is already exist")
            return
        }
        if(password1.text == "" || password2.text == "")
        {
            showMessage(msg: "Please Enter a Password Twice")
            return
        }
        if(password1.text != password2.text)
        {
            showMessage(msg: "Please Enter the Same Password")
            return
        }
        // can check psw pattern latter
        upload()
        self.performSegue(withIdentifier: "gotoMain2", sender: view)
    }
    
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func upload()
    {
        let newPlayer = firebaseRef!.child(username.text!)
        newPlayer.setValue(["name":username.text!,"password":password1.text!])
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoMain2") {
            let controller = segue.destination as! MainController
            controller.username = self.username.text
        }
    }
 

}
