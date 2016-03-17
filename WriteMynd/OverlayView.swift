//
//  OverlayView.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 16/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation

enum OverlayMode{
    case None
    case Left
    case Right
}


class OverlayView: UIView {
    var overlayState:OverlayMode = OverlayMode.None
}