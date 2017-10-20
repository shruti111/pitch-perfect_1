//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by shruti choksi on 20/10/17.
//

import UIKit

class RecordedAudio: NSObject {
    
    var filePathUrl : URL!
    var title: String!
    init(filePathUrl : URL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
