//
//  ProfileController.swift
//  FIT5140Final
//
//  Created by duo pan on 22/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

// can not change name
class ProfileController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    
    let storage = Storage.storage(url:"gs://fit5140-e5b30.appspot.com")
    var storageRef: StorageReference?
    
    
    var player:Player?
    
    var username:String!
    var score:Int!
    var treename:String!
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tfScore: UILabel!
    @IBOutlet var treeImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        download()
        tfName.text = self.username
        tfPassword.text = ""
        tfName.isEnabled = false
        tfPassword.isEnabled = false
        self.imageView.contentMode = .scaleAspectFit
        tfScore.text = "Your total score since registration is \(score!)"
        
        storageRef = storage.reference()
        let photoRef = storageRef?.child(username + ".png")
        photoRef?.getData(maxSize: 1 * 10240 * 10240) { data, error in
            if let _ = error {
                self.showMessage(msg: "Your photo size is too large!")
                self.imageView.image = #imageLiteral(resourceName: "default")
            } else {
                let image = UIImage(data: data!)
                self.imageView.image = image
            }
        }
        
        imageView.layer.borderWidth = 1
        treeImgView.image = UIImage(named: self.treename)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func download(){
        firebaseRef = Database.database().reference(withPath:"Players")
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: AnyObject]
                let name = dict["name"] as! String
                if(name == self.username)
                {
                    self.player?.name = name
                    self.player?.password = dict["password"] as! String
                }
            }
        })
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    

    @IBAction func editPassword(_ sender: Any) {
        tfPassword.isEnabled = !tfPassword.isEnabled
    }
  
    @IBAction func save(_ sender: Any) {
        //  change password if necessary
        if (tfPassword.text != "")
        {
            let newPlayer = firebaseRef!.child(self.username)
            newPlayer.setValue(["name":self.username,"password":tfPassword.text!])
        }
        // save photo
        let photoRef = storageRef?.child(username + ".png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let data = UIImagePNGRepresentation(self.imageView.image!)!
        photoRef?.putData(data, metadata: metadata)

        GiFHUD.setGif("hud1.gif")
        GiFHUD.showForSeconds(1)
    }
    
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let warnInfo = UIAlertController(title: "Warning", message: "Can not access photo library!", preferredStyle: UIAlertControllerStyle.alert)
            let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            warnInfo.addAction(okAlertAction)
            self.present(warnInfo,animated:true, completion:nil)
            return
        }
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated:true, completion:nil)
    }
    // when user choose a picture, the function will be called
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imgData : NSData = UIImagePNGRepresentation(selectedImage!)! as NSData
        imageView.image = UIImage(data: imgData as Data)!
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
