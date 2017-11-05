//
//  InitialController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class InitialController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var tfInitialHP: UITextField!             // initial credits
    @IBOutlet var tfMaxHP: UITextField!                 // target credits
    @IBOutlet var tfMissionInterval: UITextField!       // mission interval
    @IBOutlet var tfMissionDuration: UITextField!       // mission duration
    
    @IBOutlet var imageView: UIImageView!               // tree image (60 kinds)
    
    var imageName = "tree1"                             // default tree image
    
    var settings = GameSetting()                        // store settings
    var username:String!
    var background: UIView?                             // show image in full screen
    
    var totalScore:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference: click image to full screen
        //http://blog.csdn.net/qq_30513483/article/details/51115918
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        self.imageView.isUserInteractionEnabled = true
        
        self.tfInitialHP.delegate = self
        self.tfMaxHP.delegate = self
        self.tfMissionInterval.delegate = self
        self.tfMissionDuration.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // click image to make it full screen
    func tapHandler(sender: UITapGestureRecognizer) {
        let bgView = UIView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)!))
        bgView.backgroundColor = UIColor.gray
        self.view.addSubview(bgView)
        background = bgView
        let imgView = UIImageView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)!))
        imgView.image = UIImage(named: self.imageName)
        imgView.contentMode = .scaleAspectFit;
        bgView.addSubview(imgView)
        imgView.isUserInteractionEnabled = true
        // click to exit full screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeHandler))
        imgView.addGestureRecognizer(tapGesture)
        showAnim(aView: bgView)
    }
    
    func closeHandler(sender: UITapGestureRecognizer)
    {
        background?.removeFromSuperview()
    }
    
    func showAnim(aView: UIView)
    {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.2
        var values = [Any]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        aView.layer.add(animation, forKey: nil)
    }
    
    // randomly return a tree image from 60 images
    @IBAction func generateTree(_ sender: Any) {
        // tree1 -- tree60 images
        let no = arc4random_uniform(UInt32(60)) + 1
        self.imageName = "tree\(no)"
        imageView.image = UIImage(named: self.imageName)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startNewGame") {
            let controller = segue.destination as! GameController
            getSettings()
            controller.settings = self.settings
            controller.username = self.username
            controller.historyList = []
            controller.totalScore = self.totalScore
        }
    }
    

    // do validation
    func getSettings()
    {
        if tfInitialHP.text == "" || tfMaxHP.text == "" || tfMissionInterval.text == "" ||
            tfMissionDuration.text == ""{
            showMessage(msg: "Please Enter all blank fields!")
            return
        }
        settings.initialHP = Int(tfInitialHP.text!)!
        settings.maxHP = Int(tfMaxHP.text!)!
        settings.missionInterval = Int(tfMissionInterval.text!)!
        settings.missionDuration = Int(tfMissionDuration.text!)!
        settings.currTree = self.imageName
        settings.currMission = "no"
        settings.timeLeft = Int(tfMissionInterval.text!)!
        if settings.initialHP >= settings.maxHP{
            showMessage(msg: "Initial Value should less than Max HP!")
            return
        }
    }
    
    // pop up dialog to give user feedback
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // do validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // can only be numbers
            let proposeLength = (textField.text?.characters.count)! - range.length + string.characters.count
            if proposeLength > 5 {//max 5 digitals
                return false
            }
            if string != ""{// enable delete key
                let number = Int(string) // only numbers
                if number == nil {
                    return false
                }
            }
      
        return true
    }
    
    // touch background to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
