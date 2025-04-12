//
//  CGFloat+Extensions.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//



import SwiftUI

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
    
}


extension CGFloat {
    var radians: CGFloat { self * .pi / 180 }
}
