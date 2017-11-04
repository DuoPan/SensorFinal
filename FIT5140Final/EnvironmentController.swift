//
//  EnvironmentController.swift
//  FIT5140Final
//
//  Created by duo pan on 20/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class EnvironmentController: UIViewController {
    @IBOutlet var meter: MAThermometer!
    @IBOutlet var temper: UILabel!
    @IBOutlet var slider: UISlider!

    var envData : EnvironmentData!
    var timerGetData:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        envData = EnvironmentData()
        timerGetData = Timer.scheduledTimer(timeInterval: TimeInterval(2), target:self,
                             selector:#selector(self.download),
                             userInfo:nil,repeats:true)
        
        meter.maxValue = 50.0
        meter.minValue = -10.0
        meter.glassEffect = true
        
        download()
        
    }

    func download()
    {
        var url: URL
        //url = URL(string: "http://192.168.1.103:8080/temperature")!
        url = URL(string: "https://duopan.github.io")!
        
        // fast method to get data
        guard let envJsonData = NSData(contentsOf: url) else { return }
        let jsonData = JSON(envJsonData)
        envData.temperature = jsonData["temperature"].int!;
        
        meter.curValue = CGFloat(envData.temperature)
        temper.text = "\(envData.temperature) ℃"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timerGetData.invalidate()
    }



    @IBAction func move(_ sender: Any) {
        meter.curValue = CGFloat(slider.value)
        let str = String(format: "%.2f", meter.curValue)
        temper.text = "\(str) ℃"
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
