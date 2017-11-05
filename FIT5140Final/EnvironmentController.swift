//
//  EnvironmentController.swift
//  FIT5140Final
//
//  Created by duo pan on 20/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
// reference: https://github.com/micazeve/MAThermometer
// a temperature meter can customer-define colors and size

class EnvironmentController: UIViewController {
    @IBOutlet var meter: MAThermometer!             // temperature meter
    @IBOutlet var temper: UILabel!                  // temperature label
    @IBOutlet var meterH: MAThermometer!            // humidity meter
    @IBOutlet var humidity: UILabel!                // humidity label
    
    var envData : EnvironmentData!                  // store environment data
    var timerGetData:Timer!                         // fetch data every 2 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        envData = EnvironmentData()
        timerGetData = Timer.scheduledTimer(timeInterval: TimeInterval(2), target:self,
                             selector:#selector(self.download),
                             userInfo:nil,repeats:true)
        
        meter.maxValue = 50.0
        meter.minValue = -10.0
        meter.glassEffect = true
        meterH.maxValue = 100.0
        meterH.minValue = 0.0
        meterH.glassEffect = true
        meter.arrayColors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.lightGray, UIColor.white]
        download()
        
    }

    func download()
    {
        var url: URL
//        url = URL(string: "http://192.168.1.103:8080/temperature")!
        url = URL(string: "https://duopan.github.io")!
        
        // fast method to get data
        guard let envJsonData = NSData(contentsOf: url) else { return }
        let jsonData = JSON(envJsonData)
        if jsonData["temperature"].int != nil && jsonData["humidity"].int != nil && jsonData["light"].int != nil && jsonData["rain"].int != nil && jsonData["fire"].int != nil
        {
            envData.temperature = jsonData["temperature"].int!;
            envData.humidity = jsonData["humidity"].int!;
            envData.light = jsonData["light"].int!;
            envData.rain = jsonData["rain"].int!;
            envData.fire = jsonData["fire"].int!;
        }
        meter.curValue = CGFloat(envData.temperature)
        meterH.curValue = CGFloat(envData.humidity)
        temper.text = "\(envData.temperature) ℃"
        humidity.text = "\(envData.humidity) %"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timerGetData.invalidate()
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
