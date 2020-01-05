//
//  ViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    /// リクエストするURL
    let url = URL(string: "http://localhost:3000/api/v1/users")
    
    
    /// ユーザー名を格納
    var usersModel: [[String: Any]]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getModel()
    }
    
    
    
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = usersModel?[indexPath.row]["name"] as? String
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                postRequest()
        putRequest(at: indexPath.row)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersModel == nil {
            return 1
        }
        
        return usersModel!.count
    }
    
    
    
    @objc func refresh(sender: UIRefreshControl) {
        getModel()
        sender.endRefreshing()
    }
    
    
    
    
    
    // MARK: Request
    
    /// 全ユーザー名を取得する
    func getModel() {
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url!) { data, response, error in

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [Any]
                self.usersModel = json.map { (user) -> [String: Any] in
                    print(user)
                    return user as! [String: Any]
                    
                }
            } catch {
                AlertManager().alertAction(viewController: self, title: "Error", message: error as! String, handler: { (action) in
                    return
                })
                return
            }
            
        }
        task.resume()
        
        
    }
    
    
    /// ユーザー名を作成する
    func postRequest() {
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "user":["name":"新ユーザ"]
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
            
        } catch {
            print("エラー")
        }
    }
    
    
    /// ユーザ名を更新する
    func putRequest(at row: Int) {
        
        let acccesURL = URL(string: String("\(url!)/\((String(row + 1)))"))
           var request = URLRequest(url: acccesURL!)
           request.httpMethod = "PUT"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let params:[String:Any] = [
               "user":["name":"更新名"]
               
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
           } catch {
               print("エラー")
           }
       }

    

}
