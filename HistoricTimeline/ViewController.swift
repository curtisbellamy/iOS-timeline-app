//
//  ViewController.swift
//  HistoricTimeline
//
//  Created by Curtis Bellamy on 2019-11-08.
//  Copyright © 2019 BCIT Development. All rights reserved.
//

import UIKit
import Darwin
import MBCircularProgressBar

class ViewController: UIViewController {
    
    

    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.progressView.value = 0
        
        
        let color1 = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) /* #ffffff */
    
        self.picker.setValue(color1, forKey: "textColor")
        
        
        
        let hoursPassed = 13.76 * 1000000000 * 8760
        let years = 13.76 * 1000000000
        
        print(years)
        
        let e = Darwin.M_E
        
        let equation = pow(e, 20.3444 * pow(0.4, 3) + 3) - pow(e, 3)
        
        var x : Double = 0
        while x <= 1.01 {
            
            print(2012 - (pow(e, 20.3444 * pow(x, 3) + 3) - pow(e, 3)) , ": " , x )
            x += 0.05
        }
        
        
//        print(equation)
//
//        print(hoursPassed)
//        print(daysPassed)
        
    }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
    
    
    @IBAction func startClicked(_ sender: Any) {
            self.progressView.value = 0
            
            UIView.animate(withDuration: picker.countDownDuration) {
                       self.progressView.value = 100
            }

    }
    
    @IBAction func stopClicked(_ sender: Any) {
        self.progressView.value = 0

    }


}

