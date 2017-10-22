//
//  RankingDetailController.swift
//  FIT5140Final
//
//  Created by duo pan on 21/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class RankingDetailController: UIViewController {

    @IBOutlet var labelName: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    var player: RankingData! {
        didSet (newPlayer) {
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        labelName?.text = player.name
    }
    
    
}

extension RankingDetailController: PlayerSelectionDelegate {
    func playerSelected(newPlayer: RankingData) {
        player = newPlayer
    }
}
