//
//  StringExtensions.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 25.09.2024.
//

import UIKit

// MARK: Extensions

extension NSMutableAttributedString {
    
    func setFont(_ font: UIFont, forText text: String) {
        let range = self.mutableString.range(of: text, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}

extension String {
    func cutString(at character: Character) -> String {
        var newString = ""
        for char in self {
            if char != character {
                newString.append(char)
            } else {
                break
            }
        }
        return newString
    }
}
