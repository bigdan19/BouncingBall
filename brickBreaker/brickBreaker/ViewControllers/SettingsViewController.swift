//
//  SettingsViewController.swift
//  brickBreaker
//
//  Created by Daniel on 08/03/2021.
//  Copyright © 2021 Daniel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var ballName = "greyball"
    
    
    @IBOutlet weak var savedLabel: UIImageView!
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func greyBallChoosen(_ sender: Any) {
        BallData.ballName = "greyball"
        if savedLabel.isHidden == true {
            savedLabel.isHidden = false
        }
    }
    
    @IBAction func blueBallChoosen(_ sender: Any) {
        BallData.ballName = "blueball"
        if savedLabel.isHidden == true {
            savedLabel.isHidden = false
        }
    }
    
    @IBAction func redBallChoosen(_ sender: Any) {
        BallData.ballName = "redball"
        if savedLabel.isHidden == true {
            savedLabel.isHidden = false
        }
    }
}
