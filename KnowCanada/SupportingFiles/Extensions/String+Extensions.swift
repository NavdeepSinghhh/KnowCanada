//
//  String+Extensions.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 7/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import UIKit

extension String {
    // helper method to return the height of string with respect to the enclosing container and font
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(boundingBox.height)
    }
}
