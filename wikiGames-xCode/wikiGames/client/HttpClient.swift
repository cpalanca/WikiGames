//
//  HttpClient.swift
//  wikiGames
//
//  Created by dam on 06/02/2020.
//  Copyright © 2020 Carlos Palanca Giménez. All rights reserved.
//

import Foundation

class HttpClient {
    
    static let base = "https://informatica.ieszaidinvergeles.org:9062/proyecto/public/api/"
    static let baseYoutube = "https://www.googleapis.com/youtube/v3/"
    
    class func delete(_ route: String, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        return request(route, "delete", nil, callBack)
    }
    
    class func delete(_ route: String, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, "delete", nil, callBack)
    }
    
    class func dict2Json(_ data: [String:Any]) -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: data as Any, options: []) else {
            return nil
        }
        return json
    }
    
    class func get(_ route: String, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
       return request(route, "get", nil, callBack)
    }
    
    class func get(_ route: String, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
       return request(route, "get", nil, callBack)
    }
    
    class func getYoutube(_ route: String, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
       return requestYoutube(route, "get", nil, callBack)
    }
    
    class func getYoutube(_ route: String, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
       return requestYoutube(route, "get", nil, callBack)
    }
    
    class func post(_ route: String, _ data: [String:Any], _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        return request(route, "post", data, callBack)
    }
    
    class func post(_ route: String, _ data: [String:Any], _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, "post", data, callBack)
    }
    
    class func put(_ route: String, _ data: [String:Any], _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        return request(route, "put", data, callBack)
    }
    
    class func put(_ route: String, _ data: [String:Any], _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, "put", data, callBack)
    }
    
    class func request(_ route: String, _ method: String, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        return request(route, method, nil, callBack)
    }
    
    class func request(_ route: String, _ method: String, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, method, nil, callBack)
    }
    
    class func request(_ route: String, _ method: String, _ data: [String:Any]?, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: base + route) else {
            return false
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != "get" && data != nil {
            guard let diccionario = dict2Json(data!) else {
                return false
            }
            urlRequest.httpBody = diccionario
        }
        let task = sesion.dataTask(with: urlRequest, completionHandler: callBack)
        task.resume()
        return true
    }
    
    class func requestYoutube(_ route: String, _ method: String, _ data: [String:Any]?, _ callBack: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> Bool {
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: baseYoutube + route) else {
            return false
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != "get" && data != nil {
            guard let diccionario = dict2Json(data!) else {
                return false
            }
            urlRequest.httpBody = diccionario
        }
        let task = sesion.dataTask(with: urlRequest, completionHandler: callBack)
        task.resume()
        return true
    }
    
    class func request(_ route: String, _ method: String, _ data: [String:Any]?, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, method, data) { (data, response, error) in
            if response == nil || error != nil || data == nil {
                //print("nil")
                callBack(nil)
            } else {
                //print("no nil")
                if let printData = String(data: data!, encoding: .utf8) {
                    //print(printData)
                }
                callBack(data!)
            }
        }
    }
    
    class func requestYoutube(_ route: String, _ method: String, _ data: [String:Any]?, _ callBack: @escaping ((Data?) -> Void)) -> Bool {
        return request(route, method, data) { (data, response, error) in
            if response == nil || error != nil || data == nil {
                //print("nil")
                callBack(nil)
            } else {
                //print("no nil")
                if let printData = String(data: data!, encoding: .utf8) {
                    //print(printData)
                }
                callBack(data!)
            }
        }
    }
    
    class func upload(route: String,
                      fileName:String,
                      fileParameter: String,
                      fileData: Data,
                      callBack: @escaping ((Data?) -> Void)) -> Bool{
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: base + route) else {
            return false
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(fileParameter)\"; filename=\"\(fileName)\"\r\n".utf8))
        body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        urlRequest.httpBody = body
        
        let task = sesion.dataTask(with: urlRequest) { (data, response, error) in
            if response == nil || error != nil || data == nil {
                //print("nil")
                callBack(nil)
            } else {
                //print("no nil")
                if let printData = String(data: data!, encoding: .utf8) {
                    print(printData)
                }
                callBack(data!)
            }
        }
        
        task.resume()
        return true
    }
    
    class func upload(route: String,
                      filePath: String,
                      fileName: String,
                      fileParameter: String,
                      formData: [String:String] = [:],
                      callBack: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void) {
        //let site = base + route
        guard let url = URL(string: base + route) else {
            return
        }
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        if formData.count > 0 {
            for (name, value) in formData {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(fileParameter)\"; filename=\"\(fileName)\"\r\n".utf8))
            body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
            let fileUrl = URL(string: filePath)
            let data = try? Data(contentsOf: fileUrl!)
            body.append(data!)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
            request.httpBody = body
        }
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: request, completionHandler: callBack)
        task.resume()
    }
    
}
