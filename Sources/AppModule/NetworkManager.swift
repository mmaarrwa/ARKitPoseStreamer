import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()

    // We removed the hardcoded hostString property
    private let portNumber: UInt16 = 5005

    private var connection: NWConnection?
    private var isStarted: Bool = false

    private init() {}

    // ✅ CHANGED: Now accepts ipAddress as an argument
    func start(ipAddress: String) {
        // If already started, stop first to restart with new IP
        if isStarted {
            stop()
        }
        
        // ✅ FIXED: Direct assignment since NWEndpoint.Host doesn't return Optional
        let host = NWEndpoint.Host(ipAddress)
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
        print("NetworkManager started -> \(ipAddress):\(portNumber)")
    }

    func stop() {
        connection?.cancel()
        connection = nil
        isStarted = false
        print("NetworkManager stopped")
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