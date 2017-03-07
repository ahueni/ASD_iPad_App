//
//  DiskFile.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 07.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import FontAwesome_swift

class DiskFile{
    
    let displayName: String
    let isDirectory: Bool
    let fileType : DiskFileType
    let filePath : URL
    
    init(url : URL)
    {
        displayName = url.lastPathComponent
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        isDirectory = isDir.boolValue
        fileType = isDir.boolValue ? .Directory : .Default
        filePath = url.resolvingSymlinksInPath()
    }
    
    enum DiskFileType: String {
        /// Directory
        case Directory = "directory"
        /// GIF file
        case GIF = "gif"
        /// JPG file
        case JPG = "jpg"
        /// PLIST file
        case JSON = "json"
        /// PDF file
        case PDF = "pdf"
        /// PLIST file
        case PLIST = "plist"
        /// PNG file
        case PNG = "png"
        /// ZIP file
        case ZIP = "zip"
        /// Any file
        case Default = "file"
    }
    
    public func image(size: CGSize, color: UIColor) -> UIImage {
        
        switch fileType {
        case .Directory:
            return UIImage.fontAwesomeIcon(name: .folderO, textColor: color, size: size)
        case .JPG, .PNG, .GIF:
            return UIImage.fontAwesomeIcon(name: .fileImageO, textColor: color, size: size)
        case .PDF:
            return UIImage.fontAwesomeIcon(name: .filePdfO, textColor: color, size: size)
        case .ZIP:
            return UIImage.fontAwesomeIcon(name: .fileZipO, textColor: color, size: size)
        default:
            return UIImage.fontAwesomeIcon(name: .fileO, textColor: color, size: size)
        }
        
    }
}
