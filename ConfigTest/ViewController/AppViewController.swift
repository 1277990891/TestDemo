//
//  AppViewController.swift
//  ConfigTest
//
//  Created by li bo on 11/8/17.
//  Copyright © 2017 li bo. All rights reserved.
//

import Foundation

class AppViewController: UIViewController {

#if CONFIGTESTDEMO_BRANDING
    let vc = MainViewController.init()
    func actions() -> Double {
        let con = MainViewController.init()
        let a = 10
        print("a = \(a)", con.superclass!)

        return 1
    }
#else
    let vc = ViewController.init()
    func actions() -> Double {
        return 2
    }
#endif


#if DEBUG
    let con = MainViewController.init()

#endif


}
