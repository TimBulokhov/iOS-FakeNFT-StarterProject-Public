//
//  GeometricParams.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import UIKit

struct GeomitricParams {
    let cellCount: CGFloat
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: CGFloat, leftInset: CGFloat,
         rightInset: CGFloat, cellSpacing: CGFloat) {
        
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + (cellCount - 1) * cellSpacing
    }
}
