//
//  InitialController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class InitialController: UIViewController {

    @IBOutlet var tfInitialHP: UITextField!
    @IBOutlet var tfMaxHP: UITextField!
    @IBOutlet var tfMissionInterval: UITextField!
    @IBOutlet var tfLowTemp: UITextField!
    @IBOutlet var tfHighTemp: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    var imageName = "tree1"
    
    var settings = GameSetting()
    var allMissions :[String] = []
   
    var background: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference: click image to full screen
        //http://blog.csdn.net/qq_30513483/article/details/51115918
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        self.imageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
            controller.allMissions = self.allMissions
        }
    }
    

    
    func getSettings()
    {
        settings.initialHP = Int(tfInitialHP.text!)!
        settings.maxHP = Int(tfMaxHP.text!)!
        settings.missionInterval = Int(tfMissionInterval.text!)!
        settings.lowTemperature = Int(tfLowTemp.text!)!
        settings.highTemperature = Int(tfHighTemp.text!)!
        let num = settings.maxHP - settings.initialHP
        allMissions.removeAll()
        for _ in 0...num{
            allMissions.append(settings.missions[getRandomMission()])            
        }
    }
    
    func getRandomMission() -> Int
    {
        let range = settings.missions.count
        return Int(arc4random_uniform(UInt32(range)))
    }
}
