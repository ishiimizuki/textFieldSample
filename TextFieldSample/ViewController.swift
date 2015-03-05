//
//  ViewController.swift
//  TextFieldSample
//
//  Created by 石井瑞城 on 2015/03/05.
//  Copyright (c) 2015年 石井瑞城. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // UITextField改行対応させれなかったのでUITextViewにしてます
    // 3行くらいまで高さが自動で変わるようにしたいです
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    var messages: Array<String> = ["なんか", "てきとうに", "いれてます"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // キーボードの表示/非表示の監視を開始
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // キーボードの表示/非表示の監視を解除
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notif: NSNotification) {
        let info = notif.userInfo
        if let unwrappedInfo = info {
            let keyboardFrame = unwrappedInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
            let duration = unwrappedInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            
            bottomLayoutConstraint.constant = keyboardFrame.height
            UIView.animateWithDuration(duration) { [unowned self] () -> Void in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notif: NSNotification) {
        let info = notif.userInfo
        if let unwrappedInfo = info {
            let duration = unwrappedInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            
            bottomLayoutConstraint.constant = 0
            UIView.animateWithDuration(duration) { [unowned self] () -> Void in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // タッチイベントがとれなかったので、cellをタップしたらキーボード閉じるようにしてます
        inputTextView.resignFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func sendButtonTapped(sender: UIButton) {
        messages.append(inputTextView.text)
        inputTextView.text = nil
        
        tableView.reloadData()
    }
}
