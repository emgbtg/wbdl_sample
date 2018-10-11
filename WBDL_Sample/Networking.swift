//
//  Networking.swift
//  WBDL_Sample
//
//  Created by Eric Gilbert on 10/10/18.
//  Copyright © 2018 Eric Gilbert. All rights reserved.
//

import Foundation
import CommonCrypto

class Networking {
    
    var pubKey = "14d1b0a1a810fcbc99316e8a9560e284"
    var privKey = "03cb006270c462eea57919265558dedddbd0916d"
    var comics: [Comics] = []
    var totalCount: Int!
    
    func getComics( dataLoadedCallbackFunction: (() -> Void)?) {
        let timestamp = NSDate().timeIntervalSince1970
        let hash = md5(String(timestamp) + privKey + pubKey)
        let urlString =  "https://gateway.marvel.com/v1/public/comics?apikey=" + pubKey + "&hash=" + hash + "&ts=" + String(timestamp)
        if let url = NSURL(string: urlString) {
            var request = URLRequest(url: url as URL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                do{
                    if let comicObject = try? JSONDecoder().decode(Welcome.self, from: data) {
                        if comicObject.data.results.count > 0 {
                            self.comics = comicObject.data.results
                        }
                        //total count used for infinite scrolling offset calculation
                        self.totalCount = comicObject.data.total
                        
                        if dataLoadedCallbackFunction != nil {
                            DispatchQueue.main.async(execute: {
                                dataLoadedCallbackFunction!()
                            })
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    
    // function to create an md5 hash string for api authentication
    func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
}
