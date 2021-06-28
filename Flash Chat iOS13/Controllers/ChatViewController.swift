//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        // the line below will register the UITableView (Message Cell)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
     // when a new message is added this block of code is triggered
    func loadMessages() {

        // addSnapshotListener (it will add the message you wrote to the screen)is standard code used by FireStore to send and retrieve data (line 39 & 54), i know this as it says this in the guidlines for firestore (firebase.google.com/docs/firestore/quickstart#swift_3)
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []  // clears messages
            if let e = error {
            print("there was an error retireving the data from the firebase \(e)")
            } else {
                if let  snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                         let data = doc.data()
                        if let messagesender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                        let newMessage = Message(sender: messagesender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                // this will automatically scrol the user down to the  newest message
                                let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    // this is the code which will happen when the button is pressed to send the message to the other user
    @IBAction func sendPressed(_ sender: UIButton) {
        
        // this is standard code fron the fireStore  (the Auth.auth bit)which holdes the message data //
        // it will send the code to the fireStore, data can be found  at console.firebase.google.com/
        if  let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(
            data: [K.FStore.senderField: messageSender,
                   K.FStore.bodyField: messageBody,
                   K.FStore.dateField: Date().timeIntervalSince1970 // this will put the newest sent message at the bottom of the tableView
            ]) { (error) in
                if let e = error {
                print("there is an issue saving data to firestore \(e)")
                } else {
               print("the data has been saved successfully")
                    
                    
                // this will remove the message from the text field when the text has been sent, it is in a DispatchQueue as this is within a closure, if you are updating the UI within a closure (sendPressed) then it must be wrapped in a DispatchQueue
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
     
    }
        
    }
    

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
    do {
        navigationController?.popToRootViewController(animated: true)
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        // the as! MessageCell will allow give the cell variable access to the information within the MessageCell Table  view //
        cell.Label.text = message.body
        // This is a message fron the current user
        if message.sender == Auth.auth().currentUser?.email {
            
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.Label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            // This is a message from another sender
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.Label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
       
        return cell
    }
    

}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // will run when a user selects a row
        print(indexPath.row)
    }
}


