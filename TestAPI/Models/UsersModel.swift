//
//  UsersModel.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/06.
//  Copyright © 2020 m.dobashi. All rights reserved.
//


import Unbox
import Alamofire


class UsersModel: Unboxable {
    
    // MARK: Properties
    
    /// リクエストするURL
    private static let url = URL(string: "http://localhost:3000/api/v1/users")
    
    /// ID
    var id: String?
    
    /// 名前
    var name: String?
    
    /// テキスト
    var text: String?
        
    
    
    
    // MARK: Init
    
    required init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        name = try? unboxer.unbox(key: "name")
        text = try? unboxer.unbox(key: "text")
    }
    
    
    
    
    // MARK: Class Func
    
    // JSONをUsersModelに格納できるよう変換
    class func unboxDictionary(dictionary: Any) -> UsersModel {
        return  try! unbox(dictionary: dictionary as! UnboxableDictionary)
    }
    
    
    
    
    // MARK: Request
    
    /// 全ユーザー名を取得する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - callBack: getしたものを返す
    class func fetchUsers(callBack: @escaping([UsersModel], AFError?, Error?) -> ()) {
        var usersModel = [UsersModel]()
        
        AF.request(url!, method: .get, headers: .none).response { response in  
            guard response.error == nil else {
                callBack(usersModel, response.error, nil)
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .fragmentsAllowed) as! [Any]
                usersModel = json.map { user -> UsersModel in
                    print("user = \(user)")
                    
                    return UsersModel.unboxDictionary(dictionary: user)
                }
            } catch {
                callBack(usersModel, nil, error)
            }
            responsePrint(response)
            callBack(usersModel, nil, nil)
        }
        
    }
    
    
    
    
    
    
    /// ユーザー名を作成する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - name: 登録する名前
    ///   - text: 登録するテキスト
    class func postRequest(name: String, text: String, callBack: @escaping(AFError?) -> ()) {
        let params:[String:Any] = [
            "user":["name":name, "text":text]
        ]
        
        AF.request(url!, method: .post, parameters: params).response { response in
            guard response.error == nil else {
                callBack(response.error!)
                
                return
            }
            
            responsePrint(response)
            callBack(nil)
        }

    }

    
    
    /// ユーザ名を更新する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - id: ID
    ///   - name: 変更する名前
    ///   - text: 変更するテキスト
    class func putRequest(id: String?, name: String, text: String, callBack: @escaping(AFError?) -> ()) {
        
        guard let _id = id else {
            print("idの取得に失敗")
            return
        }
        
        let acccesURL = URL(string: String("\(url!)/\(_id)"))
        
        let params:[String:Any] = [
            "user":["name":name, "text":text]
        ]
        
        
        
        AF.request(acccesURL!, method: .put, parameters: params).response { response in
            
            guard response.error == nil else {
                callBack(response.error)
                
                return
            }
            
            responsePrint(response)
            callBack(nil)
            
        }
    }
    
    
    
    
    
    // MARK: Print
    
    fileprivate class func responsePrint(_ response:AFDataResponse<Data?>?) {
        
        #if DEBUG
        if let _response = response {
            print(" --------- \(String(describing: _response.response!.url!)) \(String(describing: _response.request!.httpMethod!)) response Start --------- ")
            print(_response.response!)
            print(" --------- \(String(describing: _response.response!.url!)) \(String(describing: _response.request!.httpMethod!)) response End --------- ")
        } else {
            print("NO Response")
        }
        #endif
        
    }
    
    
    
    
    
    
    
}


