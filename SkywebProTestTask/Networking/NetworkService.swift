//
//  NetworkService.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver


protocol ImageDataFetcher {
    func getImages(completion:@escaping (Result<Any, Error>) -> Void)
}

struct NetworkService: ImageDataFetcher {
    //MARK: - Variables
    private var apiKey = "BUepB7b27nzyDsio-jocI_Yiwa3HmyBje3_NuszzuAY"
    public static let shared = NetworkService()
    
    func getImages(completion:@escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=\(Int.random(in: 1..<50))&query=birthday&client_id=\(apiKey)") else {
            let error = CustomError.incorrectUrl
            SwiftyBeaver.error(error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))

                }
            }
    }
}
