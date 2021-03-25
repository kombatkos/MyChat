//
//  String + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 25.03.2021.
//

import Foundation

extension String {
    var isBlank: Bool {
        let s = self
        let cset = NSCharacterSet.newlines.inverted
        let r = s.rangeOfCharacter(from: cset)
        let ok = s.isEmpty || r == nil || s.trimmingCharacters(in: .whitespaces).isEmpty
        return ok
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
      }
}
