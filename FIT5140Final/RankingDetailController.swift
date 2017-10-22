//
//  RankingDetailController.swift
//  FIT5140Final
//
//  Created by duo pan on 21/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

class RankingDetailController: UIViewController {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var imageView: UIImageView!
 
    
    let storage = Storage.storage(url:"gs://fit5140-e5b30.appspot.com")
    var storageRef: StorageReference?
    
    
    
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
        if (player == nil){
            labelName?.text = "Loading..."
        }
        else{
            labelName?.text = player.name
            storageRef = storage.reference()
            var photoRef = storageRef?.child((labelName?.text!)! + ".png")
            photoRef?.getData(maxSize: 1 * 10240 * 10240) { data, error in
                if let error = error {
                    self.imageView.image = #imageLiteral(resourceName: "default")
                } else {
                    let image = UIImage(data: data!)
                    self.imageView.image = image
                }
            }
        }
    }
    
    
}

extension RankingDetailController: PlayerSelectionDelegate {
    func playerSelected(newPlayer: RankingData) {
        player = newPlayer
    }
}
