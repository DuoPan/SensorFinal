//
//  LoginController.swift
//  FIT5140Final
//
//  Created by duo pan on 17/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

//reference:
//https://github.com/StoneLeon/STLBGVideo

class LoginController: STLVideoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let gameNameImage = #imageLiteral(resourceName: "gamename")
        
        let gameNameLayer = createLayer(position:CGPoint(x: self.view.center.x, y: (self.view.center.y + self.view.bounds.height) / 2.5)
            , backgroundColor: .clear)
        gameNameLayer.contents = gameNameImage.cgImage
        gameNameLayer.add(createAnimation(), forKey: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createLayer (position: CGPoint, backgroundColor: UIColor) -> CALayer {

        let layer = CALayer()
        layer.position = position
        layer.bounds = CGRect(x: 0, y: 0, width: 350, height: 80)
        layer.backgroundColor = backgroundColor.cgColor
        self.view.layer.addSublayer(layer)
        return layer
    }
    
    func createAnimation () -> CABasicAnimation {
        let scaleAni = CABasicAnimation()
        scaleAni.keyPath = "transform.scale"
        scaleAni.fromValue = 0.1
        scaleAni.toValue = 2
        scaleAni.duration = 2.5;
        scaleAni.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAni.repeatCount = 1
        
        return scaleAni;
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



