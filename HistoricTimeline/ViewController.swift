//
//  ViewController.swift
//  HistoricTimeline
//
//  Created by Curtis Bellamy on 2019-11-08.
//  Copyright © 2019 BCIT Development. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
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


}

