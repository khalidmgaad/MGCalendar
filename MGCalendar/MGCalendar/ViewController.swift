//
//  ViewController.swift
//  MGCalendar
//
//  Created by nawal amallou on 31/03/2020.
//  Copyright © 2020 nawal amallou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var mgCalendar: MGCalendar!
    @IBOutlet weak var label: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mgCalendar.delegate = self
    }
}

extension ViewController : MGCalendarDelegate {
    func MGCalendarDateChanged(newDate: Date) {
        self.label.text = stringFromDate(date: newDate, formate: "dd MMMM yyyy")
    }
}

