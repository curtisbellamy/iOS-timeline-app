//
//  HistoricData.swift
//  BackwardInTime
//
//  Created by Curtis Bellamy on 2019-11-18.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import Foundation

    public struct Event {
        let date : String
        let info : String

    }


public class HistoricData {
    
    
    let events = [
        Event(date: "2011/12/11", info: "Kim Jong-Il dies\nUS leaves Iraq."),
        Event(date: "1995/2/1", info: "Windows 95 debuts.\nOJ found not guilty."),
        Event(date: "1844/1/1", info: "Bicycle invented.\nWrench patened."),
        Event(date: "24000 years ago", info: "Caves painted.\nCeramic art made.\nNeanderthals extinct."),
        Event(date: "68 million years ago", info: "First flowering plants.\nChicxulub impact kills off most dinosaurs"),
        Event(date: "13.76 billion years ago", info: "Universe begins.\nFirst stars ignite."),

    ]
    
}
