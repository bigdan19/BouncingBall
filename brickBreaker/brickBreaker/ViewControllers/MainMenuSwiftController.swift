//
//  MainMenuSwiftController.swift
//  brickBreaker
//
//  Created by Daniel on 22/02/2021.
//  Copyright © 2021 Daniel. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var PlayNowIcon: UIButton!
    @IBOutlet weak var SettingsIcon: UIButton!
    @IBOutlet weak var AboutIcon: UIButton!
    
    @IBAction func PlayNowButtonPressed(_ sender: Any) {
        PlayNowIcon.setImage(UIImage(named: "PlayNowYellowIcon"), for: .normal)
    }
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        SettingsIcon.setImage(UIImage(named: "SettingsYellowIcon"), for: .normal)
    }
    
    @IBAction func AboutButtonPressed(_ sender: Any) {
        AboutIcon.setImage(UIImage(named: "AboutYellowIcon"), for: .normal)
    }
    
    
    
}
