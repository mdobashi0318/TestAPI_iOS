//
//  UsersModel.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/06.
//  Copyright © 2020 m.dobashi. All rights reserved.
//


import Unbox


class UsersModel: Unboxable {
        
    required init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        name = try? unboxer.unbox(key: "name")
    }
    
    
    /// ID
    let id: String?
    
    /// 名前
    let name: String?
    
}









