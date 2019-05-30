//
//  ApiClient.swift
//  MealDealTest
//
//  Created by Alexander Filippov on 31/05/2019.
//  Copyright © 2019 Philalex. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiClient {
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"
        
//        let params: Parameters = [
//            "access_token": token,
//            "extended": 1,
//            "v": "5.95",
//            "fields": "photo_id, photo_50"
//        ]
        
        Alamofire.request(baseUrl + path, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let items = json.arrayValue.map { Item($0) }
                completion?(.success(items))
                print(json)
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
}
