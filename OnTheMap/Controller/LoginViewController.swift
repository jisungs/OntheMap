//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by The book on 2018. 3. 21..
//  Copyright © 2018년 The book. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Variable
    var keyboardOnScreen = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: - Outlet
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var fbLoginButton: BorderedButton!
    
    //MARK: - Action
    
    //Udacity Login process
    @IBAction func loginPressed(_ sender: Any) {
        startActivityIndicator(for: self, activityIndicator, .gray)
        if checkTextFieldEmpty(){
            showAlert(nil, message:"Email or PassWord is Empty")
            stopActivityIndicator(for: self, activityIndicator)
        }else{
            UdacityClient.sharedInstance().authenticateWithLogin(idTextField.text!, passwordTextField.text!){
                (success, errorString)in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                        self.resetControllerOnSuccess()
                    }else {
                        self.showAlert(nil, message: errorString!)
                        self.resetControllerOnFailure()
                    }
                }
            }
        }
        
        
    }
    
    //FaceBook Login Process
    
    @IBAction func fbLoginPressed(_ sender: Any) {
    }
    
    //signup button pressed
    @IBAction func signUpPressed(_ sender: Any) {
        let urlString = UdacityClient.Constants.SignupPath
        let url = URL(string: urlString)
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        
    }
    
    //Login is successed it give data to loginViewControeller
    private func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier:"MainNavigationController") as! UINavigationController
        present(controller, animated:true, completion: nil)
    }
    
    //Check textfield is Empty
    private func checkTextFieldEmpty() -> Bool {
        if idTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            return true
        }
        else{
            return false
        }
    }
    
}

//textField related extention
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//reset configuration.
extension LoginViewController {
    func resetControllerOnSuccess(){
        stopActivityIndicator(for: self, activityIndicator)
        idTextField.text = nil
        passwordTextField.text = nil
    }
    
    func resetControllerOnFailure(){
        stopActivityIndicator(for: self, activityIndicator)
    }
    
    func configure(){
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
}
