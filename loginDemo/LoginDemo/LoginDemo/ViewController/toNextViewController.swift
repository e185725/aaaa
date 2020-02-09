//
//  toNextViewController.swift
//  LoginDemo
//
//  Created by 識名俊希 on 2019/12/13.
//  Copyright © 2019 本間ののか. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class toNextViewController: UIViewController {
    
    //var homeviewcon = HomeViewController()
    
    var text = String()
    var home = HomeViewController()
    let user = Auth.auth().currentUser
    var tasksList = [String]()
    var db: Firestore!
    
    @IBAction func alertbutton(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "お知らせ"
        content.body = "期限の締め切りが近いよー！"
        content.sound = UNNotificationSound.default

        
        // トリガーを設定。５秒後に通知がくる
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // UNNotificationRequestに設定したトリガー指定する
        // 直ぐに通知を表示
        let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }
    
    @IBAction func button(_ sender: Any) {
        
        label.text = "a2"
    }
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        db = Firestore.firestore()
        label.text = UserDefaults.standard.string(forKey:"key")
        text =  UserDefaults.standard.string(forKey: "key")!
        print(type(of: text))
        getmemo(str: text)
        
        
        //label.text = (UserDefaults.standard.object(forKey: "text") as! String)
        //UserDefaults.standard.removeObject(forKey: "key")
        //print(home.memo)
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //label.text = (UserDefaults.standard.object(forKey: "text") as! String)
        //受け取った値を代入
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getmemo(str :String){
        if let user = user {
            let uid = user.uid
            let docRef = db.collection("tasks").document(uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let name = document.get("\(str).memo")
                    self.label?.text = name as? String
                } else {
                    self.label?.text = "Error"
                    print("Document does not exist")
                }
            }
        }
    }

}
