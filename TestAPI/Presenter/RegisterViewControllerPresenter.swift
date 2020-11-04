//
//  RegisterViewControllerPresenter.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/08/15.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class RegisterViewControllerPresenter {
    
    /// ユーザー名を作成する
    func postRequest(name: String?, text: String?, image: String?, success: @escaping()->(Void), failure: @escaping (String? ,String)->()) {
        
        guard let name = name else {
            failure(nil, "名前が入力されていません")
            return
        }
        
        guard let text = text else {
            failure(nil, "テキストが入力されていません")
            return
        }
        
        
        UsersModel.postRequest(name: name, text: text, image: image) { afError in
            if let _afError = afError {
                print(_afError)
                failure("接続に失敗しました", "再度接続しますか?")
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
    func putRequest(id: Int?, name: String?, text: String?, image: String?, success: @escaping()->(Void), failure: @escaping (String? ,String)->()) {
        
        guard let name = name else {
            failure(nil, "名前が入力されていません")
            return
        }
        
        guard let text = text else {
            failure(nil, "テキストが入力されていません")
            return
        }
    
    
        UsersModel.putRequest(id: id, name: name, text: text, image: image) { afError in
            if let _afError = afError {
                print(_afError)
                failure("接続に失敗しました", "再度接続しますか?")
                return
                
            }
            success()
            
        }
    }
}
