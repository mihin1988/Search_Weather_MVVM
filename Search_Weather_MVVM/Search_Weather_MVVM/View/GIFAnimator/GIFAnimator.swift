//
//  GIFAnimator.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 22/03/21.
//

import Foundation
import UIKit

public class GIFAnimator {
    
    var containerView = UIView()
    
    public class var shared: GIFAnimator {
        struct Static {
            static let instance: GIFAnimator = GIFAnimator()
        }
        return Static.instance
    }
    
    var pinchImageView = UIImageView()
    
    public func showProgressView() {
        pinchImageView.loadGif(name: "tenor")
        containerView.frame = CGRect(x: 0, y: 0, width: SceneDelegate.shared?.window?.frame.width ?? 0, height: SceneDelegate.shared?.window?.frame.height ?? 0)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        pinchImageView.setCardView()
        pinchImageView.setCornerRadius()
        pinchImageView.frame = CGRect(x: (SceneDelegate.shared?.window?.frame.width ?? 0) / 2 - 50, y:(SceneDelegate.shared?.window?.frame.height ?? 0) / 2 - 50 , width: 100.0, height: 100.0)
        containerView.addSubview(pinchImageView)
        SceneDelegate.shared?.window?.addSubview(containerView)
    }
   
    public func hideProgressView() {
        containerView.removeFromSuperview()
    }
   
}
