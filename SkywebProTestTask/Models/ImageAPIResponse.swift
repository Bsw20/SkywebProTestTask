//
//  ImageAPIResponse.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftyBeaver


struct ImageAPIResponse: Decodable {
    var images: [ImageModel]
    
    public mutating func addImages(images: [ImageModel]) {
        self.images += images
    }
    
    public static func parseToModel(data: Any) -> Result<ImageAPIResponse, Error> {
        //Когда-то тут был баг, не уверен, что его исправили, поэтому парсинг два раза
        guard  JSON(data).null != NSNull(), let results = JSON(data)["results"].array else {
            let error = CustomError.parsingError
            SwiftyBeaver.error(error)
            return .failure(error)
        }
        
        
        let models:[ImageModel] = results.compactMap {
            guard let url = $0["urls"]["regular"].string,
                  let width = $0["width"].int,
                  let height = $0["height"].int else {
                SwiftyBeaver.error(CustomError.APIError)
                return nil
            }
            return ImageModel(url: url,
                       width: width,
                       height: height)
        }
        
        if models.isEmpty {
            let error = CustomError.APIError
            SwiftyBeaver.error(error.localizedDescription)
            return .failure(error)
        }
        return .success(.init(images: models))
    }
}

struct ImageModel:ImageCellViewModel, Decodable {
    var url: String
    var width: Int
    var height: Int
}
