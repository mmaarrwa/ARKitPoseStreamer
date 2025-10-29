import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()

    // ***** CHANGE THESE BEFORE BUILDING *****
    // Put your laptop (receiver) IP here (example: "192.168.1.12")
    private var hostString: String = "192.168.1.19"
    // Port on which your Python receiver listens
    private let portNumber: UInt16 = 5005

    private var connection: NWConnection?
    private var isStarted: Bool = false

    private init() {}

    func start() {
        guard !isStarted else { return }
        guard let host = NWEndpoint.Host(hostString) else {
            print("Invalid host string")
            return
        }
        guard let port = NWEndpoint.Port(rawValue: portNumber) else {
            print("Invalid port")
            return
        }
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.start(queue: .global())
        isStarted = true
        print("NetworkManager started -> \(hostString):\(portNumber)")
    }

    func stop() {
        connection?.cancel()
        connection = nil
        isStarted = false
    }

    func sendPose(_ pose: [String: Any]) {
        guard isStarted else { return }
        guard let data = try? JSONSerialization.data(withJSONObject: pose, options: []) else { return }
        connection?.send(content: data, completion: .contentProcessed({ sendError in
            if let e = sendError {
                print("Send error:", e)
            }
        }))
    }
}
