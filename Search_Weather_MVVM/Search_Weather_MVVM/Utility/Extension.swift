//
//  Extension.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 23/03/21.
//

import Foundation
import UIKit
import SDWebImage

extension NSObject {
    
    static public var className: String {
        return String(describing: self)
    }
    
    static public var nibName: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension UIView
{
    //MARK: - CARD VIEW WITH SHADOW
    func setCardView(_ shadowColor: UIColor? = UIColor.black,corRadius:CGFloat = 5.0){
        self.layer.cornerRadius = corRadius
        self.layer.masksToBounds = false
//        self.clipsToBounds = true
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero//(width: 0, height: 5)
        self.layer.shadowRadius = 3.0
    }
    
    func setCornerRadiusView(cornerRadius: CGFloat = 5.0){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    func setBorderView(colour: UIColor = Constants.navigationBarColor, borderWidth: CGFloat = 2.0) {
        self.layer.borderColor = colour.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}

extension UIImageView {
     func setCornerRadius(cornerRadius: CGFloat = 5.0){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    

    func setBorder(colour: UIColor = Constants.navigationBarColor, borderWidth: CGFloat = 2.0) {
        self.layer.borderColor = colour.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    func setImage(withURL url: String, AndPlaceholder placeholder: UIImage? = nil, completion: SDExternalCompletionBlock? = nil) {
        guard let imageURL = URL(string: url) else { return }
        sd_imageTransition = .fade
        sd_imageIndicator = SDWebImageActivityIndicator.medium
        sd_setImage(with: imageURL, placeholderImage: placeholder, options: [.retryFailed]) { (image, error, cache, url) in
            completion?(image, error, cache, url)
        }
    }
}
