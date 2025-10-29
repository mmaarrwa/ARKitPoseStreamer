import Foundation
import ARKit
import SceneKit
import simd
import Combine

final class ARManager: NSObject, ObservableObject, ARSCNViewDelegate {
    static let shared = ARManager()

    // public UI + session object
    let sceneView: ARSCNView = {
        let v = ARSCNView(frame: .zero)
        v.autoenablesDefaultLighting = true
        v.automaticallyUpdatesLighting = true
        return v
    }()

    @Published var isStreaming: Bool = false
    @Published var statusText: String = "Idle"

    private let network = NetworkManager.shared
    private var started = false

    private override init() {
        super.init()
        sceneView.delegate = self
        statusText = "Ready"
    }

    func startSessionIfNeeded() {
        guard !started else { return }
        guard ARWorldTrackingConfiguration.isSupported else {
            statusText = "ARKit not supported"
            return
        }
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.planeDetection = []
        // no scene reconstruction for minimal app; can enable later
        sceneView.session.run(config)
        sceneView.session.delegate = self
        started = true
        statusText = "AR running"
    }

    func toggleStreaming() {
        isStreaming.toggle()
        DispatchQueue.main.async {
            self.statusText = self.isStreaming ? "Streaming" : "Stopped"
        }
        if isStreaming {
            network.start()
        } else {
            network.stop()
        }
    }

    // ARSCNViewDelegate per-frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isStreaming else { return }
        guard let frame = sceneView.session.currentFrame else { return }

        // get position
        let t = frame.camera.transform
        let px = t.columns.3.x
        let py = t.columns.3.y
        let pz = t.columns.3.z

        // quaternion from transform
        let q = simd_quatf(t)
        let qx = q.vector.x
        let qy = q.vector.y
        let qz = q.vector.z
        let qw = q.vector.w

        // timestamp
        let ts = frame.timestamp

        // build dictionary
        let pose: [String: Any] = [
            "timestamp": ts,
            "position": [px, py, pz],
            "orientation": [qx, qy, qz, qw]
        ]

        network.sendPose(pose)
    }
}
