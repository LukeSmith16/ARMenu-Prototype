//
//  Float+Extensions.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 07/07/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import ARKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
