//
//  Bool.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 18.08.25.
//

import Foundation

extension Bool {
    static func ^ (lhs: Bool, rhs: Bool) -> Bool {
        return (lhs && !rhs) || (!lhs && rhs)
    }
}
