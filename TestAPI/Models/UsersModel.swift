//
//  UsersModel.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/06.
//  Copyright © 2020 m.dobashi. All rights reserved.
//


import Unbox


class UsersModel: Unboxable {
    
    
    /// リクエストするURL
    private static let url = URL(string: "http://localhost:3000/api/v1/users")
        
    required init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        name = try? unboxer.unbox(key: "name")
        text = try? unboxer.unbox(key: "text")
    }
    
    
    /// ID
    let id: String?
    
    /// 名前
    let name: String?
    
    /// テキスト
    let text: String?
    
    
    // JSONをUsersModelに格納できるよう変換
    class func unboxDictionary(dictionary: Any) -> UsersModel {
        return  try! unbox(dictionary: dictionary as! UnboxableDictionary)
    }
    
    
    
    
    
    // MARK: Request
    

    
    /// 全ユーザー名を取得する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - callBask: getしたものを返す
    class func getrequest(viewController: UIViewController, callBask: @escaping([UsersModel])->()) {
        
        var usersModel = [UsersModel]()
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let _response = response {
                print(_response)
            } else {
                print("NO RESPONSE")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [Any]
                usersModel = json.map { (user) -> UsersModel in
                    print(user)
                    return UsersModel.unboxDictionary(dictionary: user)
                }
            } catch {
                AlertManager().alertAction(viewController: viewController, title: "Error", message: error as! String, handler: { (action) in
                    return
                })
                return
            }
            callBask(usersModel)
        }
        task.resume()
        
    }
    
    
    
    
    
    
    /// ユーザー名を作成する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - name: 登録する名前
    ///   - text: 登録するテキスト
    class func postRequest(viewController: UIViewController, name: String, text: String) {
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "user":["name":name, "text":text]
        ]
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                print("data")
                print(data!)
                print("respnse")
                print(response!)
                
            })
            task.resume()
            
            AlertManager().alertAction(viewController: viewController,
                                       title: "", message: "名前を保存しました") { _ in
                                        viewController.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
        } catch {
            AlertManager().alertAction(viewController: viewController,
                                       title: "", message: "エラーが発生しました") { _ in return
                                        
            }
            return
        }
        
    }

    
    
    /// ユーザ名を更新する
    /// - Parameters:
    ///   - viewController: 呼び出し元のVIewController
    ///   - id: ID
    ///   - name: 変更する名前
    ///   - text: 変更するテキスト
    class func putRequest(viewController: UIViewController, id: String?, name: String, text: String) {
        
        guard let id = id else {
            print("idの取得に失敗")
            return
        }
        
        let acccesURL = URL(string: String("\(url!)/\(id)"))
           var request = URLRequest(url: acccesURL!)
           request.httpMethod = "PUT"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let params:[String:Any] = [
               "user":["name":name, "text":text]
           ]
           
           
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
               let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                   print("data")
                   print(data!)
                   print("respnse")
                   print(response!)
                   
               })
               task.resume()
            
            AlertManager().alertAction(viewController: viewController,
                                             title: "", message: "名前を更新しました") { _ in
                                              viewController.dismiss(animated: true) {
                                                  NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                              }
                  }
           } catch {
               AlertManager().alertAction(viewController: viewController,
                                          title: "", message: "エラーが発生しました") { _ in return
                                           
               }
               return
           }
       }

    

    
    
}


