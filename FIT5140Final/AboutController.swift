//
//  AboutController.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet var duo: UIImageView!
    @IBOutlet var xuan: UIImageView!
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPrevious))
        
        duo.layer.borderWidth = 1
        duo.layer.masksToBounds = false
        duo.layer.cornerRadius = duo.frame.height/2
        duo.clipsToBounds = true
        
        xuan.layer.borderWidth = 1
        xuan.layer.masksToBounds = false
        xuan.layer.cornerRadius = xuan.frame.height/2
        xuan.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showWeb2(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.tag == 100{
            self.url = "https://github.com/cemolcay/GiFHUD-Swift"
        }else if (btn.tag == 101){
            self.url = "https://github.com/MinMao-Hub/MMShareSheet"
        }else if (btn.tag == 102){
            self.url = "https://github.com/StoneLeon/STLBGVideo"
        }
        self.performSegue(withIdentifier: "gotoRef1", sender: self.view)
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoRef1") {
            let controller = segue.destination as! ReferenceController
            controller.urlStr = self.url
        }
        
    }
    

}
