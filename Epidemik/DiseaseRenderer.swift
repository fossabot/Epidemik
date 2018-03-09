//
//  DiseaseRenderer.swift
//  Epidemik
//
//  Created by Ryan Bradford on 1/13/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import MapKit

public class DiseaseRenderer: MKCircleRenderer {
	
	var map: MapOverlayCreator
	
	public init(overlay: MKOverlay, map: MapOverlayCreator) {
		self.map = map
		super.init(overlay: overlay)
	}
	
	override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		super.draw(mapRect, zoomScale: zoomScale, in: context)
	}
	
}
