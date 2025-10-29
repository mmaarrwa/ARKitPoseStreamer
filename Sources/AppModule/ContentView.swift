import SwiftUI
import ARKit

struct ContentView: View {
    @StateObject private var arManager = ARManager.shared

    var body: some View {
        ZStack {
            ARViewContainer(arManager: arManager)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Text(arManager.statusText)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Spacer()
                    Button(action: {
                        arManager.toggleStreaming()
                    }) {
                        Text(arManager.isStreaming ? "Stop" : "Start")
                            .padding(8)
                            .background(arManager.isStreaming ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            arManager.startSessionIfNeeded()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arManager: ARManager

    func makeUIView(context: Context) -> ARSCNView {
        return arManager.sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
