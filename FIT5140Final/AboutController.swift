//
//  AboutController.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPrevious))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backToPrevious(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popViewController(animated: true)
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
