//
//  EventViewController.swift
//  BackwardInTime
//
//  Created by Curtis Bellamy on 2019-11-18.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var dateText : String = ""
    var percentageText : String = ""
    var infoText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        percentage.text = percentageText
        info.text = infoText
        date.text = dateText
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
