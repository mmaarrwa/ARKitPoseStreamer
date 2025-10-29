import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()

    // ***** CHANGE THESE BEFORE BUILDING *****
    private var hostString: String = "192.168.1.19"
    private let portNumber: UInt16 = 5005

    private var connection: NWConnection?
    private var isStarted: Bool = false

    private init() {}

    func start() {
        guard !isStarted else { return }
        
        // ✅ FIXED: Direct assignment since NWEndpoint.Host doesn't return Optional
        let host = NWEndpoint.Host(hostString)
        guard let port = NWEndpoint.Port(rawValue: portNumber) else {
            print("Invalid port")
            return
        }
        
        // ✅ Optional: Add host validation
        switch host {
        case .ipv4(let address):
            print("Connecting to IPv4: \(address)")
        case .ipv6(let address):
            print("Connecting to IPv6: \(address)")
        case .name(let name, _):
            print("Connecting to hostname: \(name)")
        @unknown default:
            print("Unknown host type")
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