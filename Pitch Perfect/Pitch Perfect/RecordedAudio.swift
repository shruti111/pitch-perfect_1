//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Shruti Pawar on 06/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    var filePathUrl : NSURL!
    var title: String!
    
    init(filePathUrl : NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
