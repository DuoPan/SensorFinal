//
//  SignupController.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

// This is sign up page
class SignupController: UIViewController {

    @IBOutlet var username: UITextField!        //login name
    @IBOutlet var password1: UITextField!       //login password
    @IBOutlet var password2: UITextField!       //password double check
    
    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    var nameList:[String]?                      //login name should be unique, it stores all existed names
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToPrevious))
        self.view.backgroundColor =  UIColor(patternImage: #imageLiteral(resourceName: "loginbg"))
        nameList = [String]()
        download()
    }

    // fetch all existed login names from firebase
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
    
    // remove observer
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    
    // called by nav bar left button
    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
    }

    // check inputs. If create success, save the new user info into firebase and navigate to main page
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
        upload()
        self.performSegue(withIdentifier: "gotoMain2", sender: view)
    }
    
    // pop up dialog to give user feedback
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // store name/psw pair in firebase
    func upload()
    {
        let newPlayer = firebaseRef!.child(username.text!)
        newPlayer.setValue(["name":username.text!,"password":password1.text!])
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoMain2") {
            let controller = segue.destination as! MainController
            controller.username = self.username.text
        }
    }
 

}
