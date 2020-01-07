//
//  ViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

/// リクエストするURL
let url = URL(string: "http://localhost:3000/api/v1/users")

/// iOS13以降でモーダルを閉じた時にViewWillAppearを呼ぶ
let ViewUpdate: String = "viewUpdate"





class ViewController: UITableViewController {

    
    
    /// テーブルビューを上からスワイプしたとき
    let refreshCtr = UIRefreshControl()
    
    
    /// ユーザー名を格納
    var usersModel: [UsersModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarAction))
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: ViewUpdate), object: nil)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshCtr
        refreshCtr.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getrequest()
    }
    
    
    
    @objc override func rightBarAction() {
        let navigationController = UINavigationController(rootViewController: RegisterViewController())
        present(navigationController, animated: true)
    }
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.textLabel?.text = usersModel?[indexPath.row].name
        cell.detailTextLabel?.text = usersModel?[indexPath.row].text
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(RegisterViewController(mode: .detail, userModel: usersModel?[indexPath.row]), animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersModel == nil {
            return 1
        }
        
        return usersModel!.count
    }
    
    
    
    
    
     /// 編集と削除のスワイプをセット
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "編集") { _,_,_  in
            let navigationController = UINavigationController(rootViewController: RegisterViewController(mode: .edit, userModel: self.usersModel?[indexPath.row]))
            self.present(navigationController, animated: true)
        }
        edit.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getrequest()
        sender.endRefreshing()
    }
    
    
    
    
    
    // MARK: Request
    
    /// 全ユーザー名を取得する
    func getrequest() {
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let _response = response {
                print(_response)
            } else {
                print("NO RESPONSE")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [Any]
                self.usersModel = json.map { (user) -> UsersModel in
                    print(user)
                    return UsersModel.unboxDictionary(dictionary: user)
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
    
    
    // MARK: Notification

    @objc func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    

}






// MARK: - CustomCell

class CustomCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
