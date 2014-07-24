//
//  EditViewController.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-07-23.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import Foundation
import UIKit

class EditViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }
}