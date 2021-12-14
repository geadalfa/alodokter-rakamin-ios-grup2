//
//  ConsultationObject.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 14/12/21.
//

import Foundation
import RealmSwift

class ConsultationObject: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var consultationDate: String = ""
    
}
