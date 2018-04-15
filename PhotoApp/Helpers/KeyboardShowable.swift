//
//  KeyboardShowable.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 16.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

typealias KeyboardAnimationInfo = (position: CGFloat, duration: TimeInterval, curve: UIViewAnimationCurve)
typealias KeyboardBlock = (KeyboardAnimationInfo) -> Void

protocol KeyboardShowable: class {}
extension KeyboardShowable {
    
    func addKeyboardObservers(_ infoChangedBlock: @escaping KeyboardBlock) {
        addObserver(for: .UIKeyboardWillShow) { [weak self] (notification) in
            guard let strongSelf = self else { return }
            infoChangedBlock(strongSelf.animationInfo(notification))
        }
        addObserver(for: .UIKeyboardWillChangeFrame) { [weak self] (notification) in
            guard let strongSelf = self else { return }
            infoChangedBlock(strongSelf.animationInfo(notification))
        }
        addObserver(for: .UIKeyboardWillHide) { [weak self] (notification) in
            guard let strongSelf = self else { return }
            var info = strongSelf.animationInfo(notification)
            info.position = 0.0
            infoChangedBlock(info)
        }
    }
    
    private func addObserver(for name: NSNotification.Name, block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { (notification) in
            block(notification)
        }
    }
    
    private func animationInfo(_ notification: Notification) -> KeyboardAnimationInfo {
        let userInfo = notification.userInfo!
        let animationInfo = self.animationInfo(userInfo)
        
        return animationInfo
    }
    
    private func animationInfo(_ userInfo: [AnyHashable : Any]) -> KeyboardAnimationInfo {
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect)
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let yPosition = abs(keyboardFrame.height)
        
        return (yPosition, duration, curve)
    }
    
}
