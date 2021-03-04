//
//  WebImageView.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyBeaver

class WebImageView: UIImageView {
    //MARK: - Variables
    private var currentUrlString: String?
    
    public var getCurrentUrl: String? {
        return currentUrlString
    }
    
    public func resetUrl() {
        self.image = nil
        self.currentUrlString = nil
    }
    
    public func set(imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            resetUrl()
            return
        }
        
        kf.indicatorType = .activity
        self.currentUrlString = imageURL
        kf.setImage(with: url)
    }
}
