//
//  Int+Ext.swift
//  note_detector
//
//  Created by Yuriy Egorov on 12/30/24.
//

extension Int {
    func mod(_ n: Int) -> Int {
        let result = self % n
        return result >= 0 ? result : result + n
    }
}
