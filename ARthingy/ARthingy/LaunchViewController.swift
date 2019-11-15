//
//  LaunchViewController.swift
//  ARthingy
//
//  Created by MacbookPro on 15.11.2019.
//  Copyright © 2019 Ata Atasoy. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var trackedImages = [UIImage]()
        
        if UIImage(named: "sosapic") != nil{
            trackedImages.append(UIImage(named: "sosapic")!)
        }
        
        if UIImage(named: "blackpic") != nil{
           trackedImages.append(UIImage(named: "blackpic")!)
        }
        
        if UIImage(named:"dogacpic") != nil{
            trackedImages.append(UIImage(named: "dogacpic")!)
        }
        
        imageView.animationImages = trackedImages
        imageView.animationDuration = 3.0
        imageView.startAnimating()
    }
}
