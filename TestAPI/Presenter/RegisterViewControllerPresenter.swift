//
//  RegisterViewControllerPresenter.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/08/15.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

class RegisterViewControllerPresenter {
    
    private(set) var model: UsersModel?
    
    /// ユーザー名を作成する
    func postRequest(name: String, text: String, success: @escaping()->(Void), failure: @escaping (String?)->()) {
        UsersModel.postRequest(name: name, text: text) { afError in
            if let _afError = afError {
                print(_afError)
                failure("接続に失敗しました")
                return
                
            }
            success()
            
        }
    }
    
    /// ユーザ名を更新する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - id: ID
    ///   - name: 変更する名前
    ///   - text: 変更するテキスト
    func putRequest(id: String?, name: String, text: String, success: @escaping()->(Void), failure: @escaping (String?)->()) {
    
        UsersModel.putRequest(id: id, name: name, text: text) { afError in
            if let _afError = afError {
                print(_afError)
                failure("接続に失敗しました")
                return
                
            }
            success()
            
        }
    }
}
