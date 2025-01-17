//
//  UIControl+Helper.swift
//  BuildUI
//
//  Created by Bin Shang on 2018/12/20.
//  Copyright © 2018 Bin Shang. All rights reserved.
//

import UIKit

extension UIControl {
    
    open func addActionHandler(_ action:@escaping (ControlClosure), for controlEvents: UIControl.Event) -> Void {
        let funcAbount = NSStringFromSelector(#function) + ",\(controlEvents)"
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        self.keyOfUnsafeRawPointer = runtimeKey
        addTarget(self, action:#selector(handleActionSender(_:)), for:controlEvents);
        objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    /// 点击回调
    @objc private func handleActionSender(_ sender:UIControl) -> Void {
        guard let keypointer = self.keyOfUnsafeRawPointer else {
            return
        }
        let block = objc_getAssociatedObject(self, keypointer) as? ControlClosure;
        if block != nil {
            block!(sender);
        }
        
    }
}
