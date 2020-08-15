//
//  UserListViewControllerPresenter.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/08/15.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation


class UserListViewControllerPresenter {
    
    private(set) var model: [UsersModel]?
    
    
    /// 全ユーザー名を取得する
    func fetchUsers(success: @escaping()->(), failure: @escaping (String?)->()) {
        UsersModel.fetchUsers() { [weak self] result, afError, error in
            
            if let _afError = afError {
                print(_afError)
                failure("接続に失敗しました")
                return
            }
            
            if let _error = error {
                print(_error)
                failure("エラーが発生しました")
                return
            }
            
            self?.model = result
            success()
        }
    }
    
    
    
    
    
    
    
    
}
