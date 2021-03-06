//
//  FriendsTableViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/6/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import SwiftMoment

class FriendsTableViewController: UITableViewController {
    
    var currentUserID : String?
    var arr = [User]()
    var arrFriendIDs = [String]()
    var db: Firestore!
    var friends : Array? = [FriendList]()
    
    
    var senderUserID = ""
    var receiverUserID = ""
    var receiverName = ""
    var receiverImageURL = ""
    var conversationID = ""
    var senderUserName = ""
    var senderImageURL = ""
    var receiverOnlineStatus = false
    var receiverUserName = ""
    
    let fs = FireStoreQueries()
    
    
    @IBOutlet var friendListTableView1: UITableView!
    
    
    let settings = FirestoreSettings()

                                    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firestore.firestore().settings = settings
                                            // [END setup]
                                            db = Firestore.firestore()
        self.view.makeToastActivity(.center)
        
        fs.getCurrentUserDetail { (uid, imageURL, name) in
            self.view.hideToastActivity()
            self.senderUserID = uid
            self.senderImageURL = imageURL
            self.senderUserName = name
            
           
        }
         self.getRealTimeFriendList()
        
//        var reference: CollectionReference?
//        reference = db.collection(["User", "b3t4Op4GRFMYp6SbCfNXIWeTvLB2", "Friends"].joined(separator: "/"))
//              friendListener = reference?.addSnapshotListener { querySnapshot, error in
//                  guard let snapshot = querySnapshot else {
//                      print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
//                      return
//                  }
//
//                  snapshot.documentChanges.forEach { change in
//                      //self.handleDocumentChange(change)
//                      print("change in collection of collectio's document ;\(change)")
//                  }
//
//              }
        
  
       
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //navigationBar.topItem.title = "some title"
        friendListTableView1.register(UINib(nibName: "FriendsTableViewCell", bundle: nil) , forCellReuseIdentifier: "FriendCell")
        //  friendListTableView1.separatorStyle = .none
        db = Firestore.firestore()
        test{
            print("testin is completed")
        }
        
        
   
        friendListTableView1.separatorStyle = .none
        self.navigationItem.title = "Friends"
        
        // var ref: DocumentReference?
        print("\(emailG)")
        
        //realTimeFriend(completion: () -> Void)
        //        realTimeFriend {
        //            self.friendListTableView1.reloadData()
        //            self.view.hideToastActivity()
        //
        //        }
        print(" here is friend list id after login: \(arrFriendIDs)")
        
    }
    
    
    
    func getRealTimeFriendList(){
        
        let userID = Auth.auth().currentUser?.uid
        self.view.hideToastActivity()
        db.collection(["User", userID!, "Friends"].joined(separator: "/")).order(by: "LastMessageTime", descending: true)//.whereField("state", isEqualTo: "CA")
          .addSnapshotListener { querySnapshot, error in
              guard let documents = querySnapshot?.documents else {
                  print("Error fetching documents: \(error!)")
                  return
              }
            
              self.friends?.removeAll()
              for i in documents{
                  let data = i.data()
                  
                  //print("here is new data\(data)")
                  
                  let fl = FriendList()
                  guard let timestamp = data["ConversationCreatedDate"] as? Timestamp else {
                      return
                  }
                  let lastDate = timestamp.dateValue()
                  fl.LastMessageTime = "\(lastDate)"
                  fl.imageURLreceiver = data["imageURL/receiver"] as? String ?? ""
                  fl.LastMessage = data["LastMessage"] as? String ?? ""
                  fl.user2Namereceiver = data["user2Name/receiver"] as? String ?? "none"
                  fl.User2 = data["User2"] as? String ?? "none"
                  self.friends?.append(fl)
                  // print("here is last message : \(fl.LastMessage)")
                  self.friendListTableView1.reloadData()
                  
                  print("\(self.friends?.count)")
              }
              
              
          }
    }
    var friendListener: ListenerRegistration?
    
    deinit {
      friendListener?.remove()
    }

    func test(c : @escaping ()-> Void){
        
      
//        db.collection("User")//.joined(separator: "/"))//.whereField("User1", isEqualTo: "CA")
//                  .addSnapshotListener { querySnapshot, error in
//                      guard let documents = querySnapshot?.documents else {
//                          print("Error fetching documents: \(error!)")
//                        c()
//                          return
//                      }
//                      for i in documents{
//                          let data = i.data()
//                          print("here is real data brand new structure : \(data)")
//
//                      }
//                     c()
//
//                  }
           
    }
//    func realTimeFriend(completion : @escaping ()->Void){
//        //   var  fID = []
//
//        let settings = FirestoreSettings()
//
//                                    Firestore.firestore().settings = settings
//                                    // [END setup]
//                                    db = Firestore.firestore()
//        db.collection("User").whereField("Email", isEqualTo: emailG)
//            .addSnapshotListener { querySnapshot, error in
//                guard let snapshot = querySnapshot else {
//                    print("Error fetching snapshots: \(error!)")
//                    //self.view.hideToastActivity()
//                    return
//                }
//                snapshot.documentChanges.forEach { diff in
//                    // if (diff.type == .added) {
//                    print("New city: \(diff.document.data())")
//                    let data = diff.document.data()
//                    let fID = data["ConversationID"] as! Array<String>
//
//                    print("here is conversation ID : \(fID)")
//                    completion()
//                    for i in fID {
//                        //
//                        // print(i)
//                        var name : String = ""
//
//
//                        self.friends?.removeAll()
//                                                        self.db.collection("Friends").whereField("CollectID", isEqualTo: i).order(by: "LastMessageTime", descending: false).getDocuments { (document, error) in
//                                                            if let error = error {
//                                                                fatalError("\(error.localizedDescription)")
//                                                            }else{
//                                                                for i in document!.documents{
//                                                                    let data = i.data()
//                                                                    print("here is new data\(data)")
//                                                                }
//                                                               // let data = document.data()
//
//                                                            }
//                                                        }
//
//                         //here is commit 8:02
//                        print("instance of conversationID : \(i)")
//                        self.db.collection("Friends").whereField("CollectionID", isEqualTo: i).order(by: "LastMessageTime", descending: true)
//                            .addSnapshotListener { (result, error) in
//                                if let error = error{
//                                    print("\(error.localizedDescription)")
//                                }else{
//                                    let fl = FriendList()
//                                    for i in result!.documents{
//                                        let data = i.data()
//                                        //print("here is new data\(data)")
//
//
//                                        guard let timestamp = data["ConversationCreatedDate"] as? Timestamp else {
//                                            return
//                                        }
//                                        let lastDate = timestamp.dateValue()
//                                        fl.LastMessageTime = "\(lastDate)"
//                                        fl.imageURLreceiver = data["imageURL/receiver"] as? String ?? ""
//                                        fl.LastMessage = data["LastMessage"] as? String ?? ""
//                                        fl.user2Namereceiver = data["user2Name/receiver"] as? String ?? "none"
//                                        fl.User2 = data["User2"] as? String ?? "none"
//                                        self.friends?.append(fl)
//                                       // print("here is last message : \(fl.LastMessage)")
//                                        self.friendListTableView1.reloadData()
//                                        completion()
//                                        print("\(self.friends?.count)")
//                                    }
//                                }
//                        }
//
//                        // end commints
//
//
//                        //                        let ref = self.db.collection("Friends").document(i)
//
//                        //                        ref.getDocument() { (document, error) in
//                        //                            if let document = document {
//                        //                                let data = document.data()
//                        //
//                        //                                let fl = FriendList()
//                        //
//                        //                                guard let timestamp = data?["ConversationCreatedDate"] as? Timestamp else {
//                        //                                    return
//                        //                                }
//                        //                                let lastDate = timestamp.dateValue()
//                        //                                fl.LastMessageTime = "\(lastDate)"
//                        //                                fl.imageURLreceiver = data?["imageURL/receiver"] as? String ?? ""
//                        //                                fl.LastMessage = data?["LastMessage"] as? String ?? ""
//                        //                                fl.user2Namereceiver = data?["user2Name/receiver"] as? String ?? "none"
//                        //                                fl.User2 = data?["User2"] as? String ?? "none"
//                        //                                self.friends?.append(fl)
//                        //                                // print("here is friendchat array list : \(self.friends)")
//                        //                                //print("here is friendchat last message  : \(a)")
//                        //                                // print("table view update : \(a)")
//                        //                                self.friendListTableView1.reloadData()
//                        //                                //self.view.hideToastActivity()
//                        //                                print("\(self.friends?.count)")
//                        //                                //print("Document does not exist in cache\(document.data())")
//                        //                            } else {
//                        //                                //fatalError("")
//                        //                                print("Document does not exist in cache\(document!.data())")
//                        //                            }
//                        //                        }
//
//
//
//
//
//                    }
//                    //}
//
//
//                }
//
//
//        }
//
//    }
//
    override func viewWillAppear(_ animated: Bool) {
               
        
    }
 
 
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        
        
        performSegue(withIdentifier: "friendToAllUser", sender: self)
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print()
        return self.friends?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        cell.lastMessageText.text = friends?[indexPath.row].LastMessage ?? "none"
        cell.selectionStyle = .none
        let url  = NSURL(string: friends?[indexPath.row].imageURLreceiver ?? "none")
        cell.avatarImageView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar.png"))
        // cell.avatarImageView.backgroundColor = UIColor.red
        if friends?[indexPath.row].user2Namereceiver == "" {
            cell.senderUsername.text =  Auth.auth().currentUser?.displayName//"testimnf" //self.senderUserName
        }else{
            cell.senderUsername.text = friends?[indexPath.row].user2Namereceiver ?? "none"
        }
        let yesterday = moment("2019-11-24")
        print("yesterday details : \(yesterday)")
        cell.lastMessageTime.text = friends?[indexPath.row].LastMessageTime ?? "none"
        //var i = staticLinker.getPastTime(for: staticLinker.getPastStatus(date: "\(self.friends?[indexPath.row].LastMessageTime)!").0)
        
       // print(i)
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        receiverUserID = self.friends?[indexPath.row].User2 ?? "nonoe"
        receiverImageURL = self.friends?[indexPath.row].imageURLreceiver ?? "none"
        receiverUserName = self.friends?[indexPath.row].user2Namereceiver ?? "none"
        receiverOnlineStatus = true
        let user = Auth.auth().currentUser
        if let user = user {
            
            let uid = user.uid
            
            senderUserID = user.uid
            //  sendImageURL = user.photoURL?
            
            
            if uid > receiverUserID {
                
                conversationID = uid + receiverUserID
                
            }else{
                conversationID =   receiverUserID + uid
            }
            
            print(conversationID)
            
        }
        performSegue(withIdentifier: "goFriendToChat", sender: self)
        print(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            let allVC = segue.destination as! AllUserTableViewController
            allVC.arr = self.arr
            
        }
        if segue.identifier == "goFriendToChat" {
            let chatVC = segue.destination as! ChatViewController
            // chatVC.senderUserID = ""
            chatVC.conversationID = self.conversationID //
            chatVC.receiverUserID = self.receiverUserID //
            chatVC.receiverName = self.receiverUserName //
            chatVC.receiverImageURL = self.receiverImageURL//
            chatVC.senderUserID = self.senderUserID //
            chatVC.senderImageURL = self.senderImageURL
            chatVC.senderUserName = self.senderUserName
            chatVC.receiverOnlineStatus = self.receiverOnlineStatus
            chatVC.firstTimeLoad = true
        }
        
//        print("here message details conversation id : \(conversationID)")
//
//        print("here message details rid: \(receiverUserID)")
//
//        print("here message details r name: \(receiverUserName)")
//
//        print("here message details r image url : \(receiverImageURL)")
//
//        print("here message details s id: \(senderUserID)")
//        print("here message details s imageurl : \(senderImageURL)")
//        print("here message details s username: \(senderUserName)")
//        print("here message details r online statust: \(receiverOnlineStatus)")
        
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
