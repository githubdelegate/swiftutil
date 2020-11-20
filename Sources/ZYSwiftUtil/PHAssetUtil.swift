//
//  PHAssetUtil.swift
//  cleaner
//
//  Created by zy on 2020/7/15.
//  Copyright © 2020 topstack. All rights reserved.
//

import Foundation
import Photos
import ObjectiveC

/// asset 大小类型
enum PHAssetSizeType {
    case more50M, size30To50M, size11To30M, size1To10M, less1M
    
    var titleForSize: String {
        switch self {
        case .more50M:
            return ">50MB"
        case .size30To50M:
            return "30-50MB"
        case .size11To30M:
            return "11-30MB"
        case .size1To10M:
            return "1-10MB"
        case .less1M:
            return "<1MB"
        default:
            return "unknow"
        }
    }
}

// 获取图片大小
extension PHAsset {
    var fileSize: Float {
        get {
            let resource = PHAssetResource.assetResources(for: self)
            if resource.count > 0 {
                let imageSizeByte = resource.first?.value(forKey: "fileSize") as! NSNumber
                let imageSizeMB = imageSizeByte.floatValue / (1024.0*1024.0)
                if imageSizeMB < 0.10 {
                    return 0.10
                }
                return imageSizeMB
            } else {
                return 0.10
            }
        }
    }
    
    /// 判断当前asset 是不是屏幕录制视频
    var isScreenRecordingVideo: Bool {
        guard self.mediaType == .video else { return false }
        if let resource = PHAssetResource.assetResources(for: self).first {
            // ios13 屏幕录制视频文件名前缀为RPReplay_,ios12前缀为ScreenRecording_
            if resource.originalFilename.hasPrefix("RPReplay_") || resource.originalFilename.hasPrefix("ScreenRecording_") {
                return true
            }
        }
        return false
    }
    
    
    /// 判断asset 是不是同一天
    /// - Parameter asset: asset description
    /// - Returns: description
    public func isInSameDay(with asset: PHAsset) -> Bool {
        guard asset.creationDate != nil && self.creationDate != nil  else {
            return false
        }
        return asset.creationDate!.isSameDay(with: self.creationDate!)
    }
    
    
    var formatDuration: String {
        let formatter = DateComponentsFormatter()
           formatter.zeroFormattingBehavior = .pad
           formatter.allowedUnits = [.minute, .second]

           if duration >= 3600 {
               formatter.allowedUnits.insert(.hour)
           }
           return formatter.string(from: duration)!
    }
}


//  设置关联属性
extension PHAsset {
    private struct AssociatedKey {
        static var hasSlectedkey = "hasSlectedkey"
        static var fileSizeKey = "fileSizeKey"
    }
    
    var hasSelected: Bool {
        get {
            return getAssociated(associatedKey: &AssociatedKey.hasSlectedkey) ?? false
        }
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.hasSlectedkey)
        }
    }
    
    var photoFileSize: Float {
        get {
            return getAssociated(associatedKey: &AssociatedKey.fileSizeKey) ?? 0.0
        }
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.fileSizeKey)
        }
    }

    var sizeType: PHAssetSizeType {
        if photoFileSize > 50 {
            return .more50M
        }
        
        if photoFileSize > 30 {
            return .size30To50M
        }
        
        if photoFileSize > 11 {
            return .size11To30M
        }
        
        if photoFileSize > 1 {
            return .size1To10M
        }
        return .less1M
    }
}

// 比较assset
extension PHAsset {
    open override var hash: Int {
        return localIdentifier.hashValue
    }
}
