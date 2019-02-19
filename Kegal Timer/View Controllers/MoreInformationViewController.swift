//
//  MoreInformationViewController.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 15/02/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController {

    @IBAction func nafcWebsiteButton(_ sender: Any) {
        guard let url = URL(string: "https://www.nafc.org/kegel") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func mayoclinicWebsitebutton(_ sender: Any) {
        guard let url = URL(string: "https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/kegel-exercises/art-20045283") else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
