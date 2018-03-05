//
//  CanadaInfo.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import Foundation.NSURL

struct CanadaInfo: Decodable {
    let title: String
    let rows: [InfoModel]
    
    enum CodingKeys: String, CodingKey {
        case title
        case rows
    }
}

struct InfoModel: Decodable {
    let title: String?
    let description: String?
    let imageHref: String?
}
