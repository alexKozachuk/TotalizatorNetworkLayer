//
//  File.swift
//  
//
//  Created by Sasha on 21/03/2021.
//

import Foundation


extension Date {
    
    var isoDateFormat: String {
        let dateFormater =  DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormater.string(from: self)
    }
    
}

