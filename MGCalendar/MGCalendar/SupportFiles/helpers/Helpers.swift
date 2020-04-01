//
//  Helpers.swift
//  MGCalendar
//
//  Created by nawal amallou on 01/04/2020.
//  Copyright © 2020 nawal amallou. All rights reserved.
//

import Foundation


func stringFromDate(date: Date,formate: String)->String?{
    let formatter = DateFormatter()
    formatter.dateFormat = formate
    guard let date = formatter.string(from: date) as String? else { return nil }
    return date
}

func dateFromString(string: String,with formate: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = formate
    guard let date = formatter.date(from: string) else { return nil }
    return date
}
