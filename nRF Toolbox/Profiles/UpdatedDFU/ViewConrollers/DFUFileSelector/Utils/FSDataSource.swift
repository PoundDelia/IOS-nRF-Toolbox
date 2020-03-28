//
//  FSDataSource.swift
//  nRF Toolbox
//
//  Created by Nick Kibysh on 27/03/2020.
//  Copyright © 2020 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct FSNodeRepresentation {
    var level: Int
    var name: String
    var collapsed: Bool
    var size: Int
    var image: UIImage
    
    var modificationDate: Date?
    var sizeInfo: String
}

struct FSDataSource {
    var items: [FSNodeRepresentation] = []
    
    mutating func updateItems(_ dir: Directory) {
        self.items = items(dir, level: 0)
    }
    
    func items(_ dir: Directory, level: Int = 0) -> [FSNodeRepresentation] {
        dir.nodes.reduce([FSNodeRepresentation]()) { (result, node) in
            var res = result
            let image = (node is Directory)
                ? ImageWrapper(icon: .folder, imageName: "folder").image
                : UIImage.icon(forFileURL: node.url, preferredSize: .smallest)
            
            let infoText: String
            if let dir = node as? Directory {
                infoText = "\(dir.nodes.count) items"
            } else {
                infoText = ByteCountFormatter().string(fromByteCount: Int64((node as! File).size))
            }
            
            res.append(FSNodeRepresentation(level: level, name: node.name, collapsed: false, size: 0, image: image!, modificationDate: node.resourceModificationDate, sizeInfo: infoText))
            if let dir = node as? Directory {
                
                res.append(contentsOf: self.items(dir, level: level + 1))
            }
            return res
        }
    }
}
