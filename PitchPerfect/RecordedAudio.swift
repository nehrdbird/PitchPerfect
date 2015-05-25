//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Neha Monga on 5/17/15.
//  Copyright (c) 2015 nemon. All rights reserved.
//

import Foundation

public class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl : NSURL, title : String){
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
}
