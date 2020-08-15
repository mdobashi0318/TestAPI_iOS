//
//  ViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - Global
/// iOS13以降でモーダルを閉じた時にViewWillAppearを呼ぶ
let ViewUpdate: String = "viewUpdate"




// MARK: - ViewController

class UserListViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {

    
    // MARK: Properties
    
    /// テーブルビューを上からスワイプしたとき
    let refreshCtr = UIRefreshControl()
    
    
    /// ユーザー名を格納
//    var usersModel: [UsersModel]? {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    
    var presenter: UserListViewControllerPresenter?
    
    
    /// 入力画面VC
    var registerViewController: UINavigationController?


    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        presenter = UserListViewControllerPresenter()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarAction))
        NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: ViewUpdate), object: nil)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshCtr
        refreshCtr.addTarget(self, action: #selector(UserListViewController.refresh(sender:)), for: .valueChanged)

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
    }
    
    
    
    // MARK: Request
    
    func fetch() {
        presenter?.fetchUsers(success: {
            self.tableView.reloadData()
        }) { error in
            AlertManager().alertAction(viewController: self, title: error, message: "", handler1: {_ in
                self.fetch()
            }) { _ in
                print("")
            }
        }
    }
    
    // MARK: NavigationButtonAction
    
    @objc override func rightBarAction() {
        let _registerViewController = RegisterViewController()
        registerViewController = UINavigationController(rootViewController: _registerViewController)
        registerViewController?.presentationController?.delegate = self
        present(registerViewController!, animated: true)
    }
    
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager().alertDeleteAction(viewController: registerViewController!, title: nil, message: "編集途中の内容がありますが削除しますか?", closeButton: "キャンセル", handler1: { [weak self] action in
            self?.registerViewController?.dismiss(animated: true)
        }) { _ in
            return
        }
    }
    
    
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.textLabel?.text = presenter?.model?[indexPath.row].name
        cell.detailTextLabel?.text = presenter?.model?[indexPath.row].text
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(RegisterViewController(mode: .detail, userModel: presenter?.model?[indexPath.row]), animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter?.model == nil {
            return 1
        }
        
        return (presenter?.model!.count)!
    }
    
    
    
    
    
     /// 編集と削除のスワイプをセット
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "編集") { [weak self] _,_,_  in
            self?.registerViewController = UINavigationController(rootViewController: RegisterViewController(mode: .edit, userModel: self?.presenter?.model?[indexPath.row]))
            self?.registerViewController?.presentationController?.delegate = self
            self?.present(self!.registerViewController!, animated: true)
        }
        edit.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    
    @objc func refresh(sender: UIRefreshControl) {
        fetch()
        sender.endRefreshing()
    }
    
    
    
    
    
    // MARK: Notification

    @objc func callViewWillAppear(notification: Notification) {
        fetch()
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
