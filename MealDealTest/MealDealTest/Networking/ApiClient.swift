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
import CoreData

class ApiClient {
    
    
    
    public func getItems(completion: ((Swift.Result<[Item], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.edadev.ru"
        let path = "/intern/"

        
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
