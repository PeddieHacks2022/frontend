//
//  ARViewContainer.swift
//  FitForm
//
//  Created by Anish Aggarwal on 2022-08-19.
//

import ARKit
import RealityKit
import SwiftUI

private var bodySkeleton: BodySkeleton?
private let bodySkeletonAnchor = AnchorEntity()

struct ARViewContainer: UIViewRepresentable {
    typealias UIViewType = ARView

    func makeUIView(context _: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)

        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)

        return arView
    }

    func updateUIView(_: ARView, context _: Context) {}
}

extension ARView: ARSessionDelegate {
    func setupForBodyTracking() {
        let configuration = ARBodyTrackingConfiguration()
        session.run(configuration)

        session.delegate = self
    }

    public func session(_: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    skeleton.update(with: bodyAnchor)
                } else {
                    bodySkeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                }
            }
        }
    }
}
