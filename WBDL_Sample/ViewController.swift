//
//  ViewController.swift
//  WBDL_Sample
//
//  Created by Eric Gilbert on 10/10/18.
//  Copyright © 2018 Eric Gilbert. All rights reserved.
//

import UIKit

import CoreFoundation
import CommonCrypto
let pubKey = "14d1b0a1a810fcbc99316e8a9560e284"
let privKey = "03cb006270c462eea57919265558dedddbd0916d"
let networking = Networking()
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        networking.getComics()
//        let timestamp = NSDate().timeIntervalSince1970
//        let hash = md5(String(timestamp) + privKey + pubKey)
//        print(hash)
//        print(timestamp)
    }
    
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


//extension Int {
//    var hexString: String {
//       // return ...
//    }
//}
//extension Data {
//    var hexString: String {
//        let string = self.map{Int($0).hexString}.joined()
//        return string
//    }
//
//    var MD5: Data {
//        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
//        _ = result.withUnsafeMutableBytes {resultPtr in
//            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
//                CC_MD5(bytes, CC_LONG(count), resultPtr)
//            }
//        }
//        return result
//    }
//}
//
//extension String {
//    var hexString: String {
//        return self.data(using: .utf8)!.hexString
//    }
//
//    var MD5: String {
//        return self.data(using: .utf8)!.MD5.hexString
//    }
//
//}
//extension Data {
//    func hexString() -> String {
//        let string = self.map{Int($0).hexString()}.joined()
//        return string
//    }
//
//    func MD5() -> Data {
//        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
//        _ = result.withUnsafeMutableBytes {resultPtr in
//            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
//                CC_MD5(bytes, CC_LONG(count), resultPtr)
//            }
//        }
//        return result
//    }
//
//}
//
//extension String {
//    func hexString() -> String {
//        return self.data(using: .utf8)!.hexString()
//    }
//
//    func MD5() -> String {
//        return self.data(using: .utf8)!.MD5().hexString()
//    }
//
//}

