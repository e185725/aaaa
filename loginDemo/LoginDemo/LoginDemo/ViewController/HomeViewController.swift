//
//  HomeViewController.swift
//  LoginDemo
//
//  Created by 本間ののか on 2019/11/16.
//  Copyright © 2019 本間ののか. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var memo = String()
    var memomemo : [String] = [""]
    let user = Auth.auth().currentUser
    var tasksList = [String]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        getUserName()
        getUserTask()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableview1,count")
        return self.tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableview2")
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        print("this is list")
        print(tasksList)
        cell.textLabel!.text = self.tasksList[indexPath.row]
        memomemo = tasksList
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //削除スワイプ
        let deletButtom = UITableViewRowAction(style: .normal, title: "delet"){(rowAction, indexPath) in self.deleteDb(forRowAt: indexPath)
            self.tasksList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //編集項目、まだ中身はからです
        let editButton = UITableViewRowAction(style: .normal, title: "Edit"){
            (rowAction, indexPath) in print("editbuttom clicked")
            self.memo = self.memomemo[indexPath.row]
            //print(self.memo)
            UserDefaults.standard.set(self.memo, forKey: "key")

            self.performSegue(withIdentifier: "toNextViewController", sender: nil)

        }
        editButton.backgroundColor = UIColor.black

        deletButtom.backgroundColor = UIColor.blue
        return [deletButtom,editButton]
    }
    //dbからuserのfirstnameをとってくる
    func getUserName(){
        if let user = user {
            let uid = user.uid
            let docRef = db.collection("users").document(uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let name = document.get("firstname")
                    self.userName?.text = name as? String
                } else {
                    self.userName?.text = "Error"
                    print("Document does not exist")
                }
            }
        }
    }
    //dbからタスクの名前ととってきて、リストに入れてる
    func getUserTask(){
        if let user = user {
            let uid = user.uid
            let taskRef = db.collection("tasks").document(uid)
            
            taskRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let tasks = document.data()?.keys
                    for i in tasks!{
                        self.tasksList.append(i)
                    }
                    print("made tastList")
                    self.tableView.reloadData()
                    
                } else {
                    print("Task does not exist")
                }
                self.tableView.reloadData()

            }
        }
            }
    
    func deleteDb(forRowAt indexPath: IndexPath){
        if let user = user {
            let uid = user.uid; db.collection("tasks").document(uid).updateData([self.tasksList[indexPath.row]:FieldValue.delete()])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
     
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            // セルの選択を解除
            tableView.deselectRow(at: indexPath, animated: true)
     
            // 別の画面に遷移
            //performSegue(withIdentifier: "toNextViewController", sender: nil)
            
            //print("\(indexPath.row)番目の行が選択されました。")
            
            memo = memomemo[indexPath.row]
            print(memo)
            UserDefaults.standard.set(memo, forKey: "key")
           
            //label.text = (UserDefaults.standard.object(forKey: "text") as! String)
        }

    
    
}
