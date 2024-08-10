//
//  ARPuzzlesScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import ARKit
import RealityKit
import SwiftUI
import SceneKit

struct MiniModelView: UIViewRepresentable {
    let modelName: String

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = false

        let scene = SCNScene()
        scnView.scene = scene

        // Завантаження .usdz моделі
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            print("Не вдалося знайти модель")
            return scnView
        }

        let modelScene = try? SCNScene(url: modelUrl, options: nil)
        let modelNode = modelScene?.rootNode.childNodes.first

        // Зменшення масштабу моделі
        modelNode?.scale = SCNVector3(0.01, 0.01, 0.01) // Зменшити до 1% від оригінального розміру

        // Додавання моделі до основної сцени
        if let modelNode = modelNode {
            scene.rootNode.addChildNode(modelNode)
        }

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}


enum ModelCategory: String, CaseIterable, Identifiable {
    case sculpture = "Скульптури"
    case artwork = "Художні роботи"
    case building = "Будівлі"
    case castle = "Замки"
    
    var id: String { rawValue }
}

struct ARModel: Identifiable {
    let id = UUID()
    let name: String
    let displayName: String
    let categories: [ModelCategory]
}


let models: [ARModel] = [
    ARModel(name: "Bosel-Mausoleum", displayName: "Модель 1", categories: [.building, .castle])
]

struct ARScreen: View {
    
    @State private var selectedCategory: ModelCategory = .building
    @State private var selectedModel: ARModel?

    var body: some View {
        NavigationStack {
            LazyVStack(alignment: .leading) {
                Text("Welcome to")
                HStack(spacing: 0) {
                    Text("AR Gallery")
                    Text("Guide")
                        .foregroundStyle(.yellow)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(ModelCategory.allCases) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category.rawValue)
                                    .padding()
                                    .background(selectedCategory == category ? Color.yellow : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }

                if models.filter({ $0.categories.contains(selectedCategory) }).isEmpty {
                    VStack {
                        Text("Поки немає моделей у цій категорії.")
                            .padding()
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 100)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(models.filter { $0.categories.contains(selectedCategory) }) { model in
                                NavigationLink {
                                    ARItemScreen(selectedModel: model)
                                } label: {
                                    MiniModelView(modelName: model.name)
                                        .frame(width: 100, height: 100) // Задайте розмір для мініатюри
                                        .background(Color.gray.opacity(0.3)) // Додайте фон або обводку, якщо потрібно
                                        .cornerRadius(10)
                                        .padding()
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding()
            .background(.blue)
        }
    }
}


struct ARItemScreen: View {
    @State private var showARView = false
    let selectedModel : ARModel?
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    MiniModelView(modelName: selectedModel?.name ?? "")
                        .frame(height: 400)
                        .background(Color.gray.opacity(0.3)) // Додайте фон або обводку, якщо потрібно
                        .cornerRadius(10)
                        .padding()

                    VStack {
                        HStack {
                            Button {
                                
                            } label: {
                                Label("Play", systemImage: "headphones")
                                    .padding(15)
                                    .foregroundStyle(.blue)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                    }
                                
                            }
                            .padding(.horizontal)
                            .offset(y: -20)
                            Spacer()
                            Button {
                                showARView.toggle()
                            } label: {
                                Label("Go", systemImage: "arkit")
                                    .padding(15)
                                    .foregroundStyle(.blue)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                    }
                                
                            }
                            .padding(.horizontal)
                            .offset(y: -20)
                            .sheet(isPresented: $showARView) {
                                if let model = selectedModel {
                                    ARViewContainer(modelName: model.name).edgesIgnoringSafeArea(.all)
                                }
                            }
                        }
                        Text("The Tomb of Taras Shevchenko is a notable mausoleum located in Ukraine. It is the final resting place of Taras Shevchenko, a revered Ukrainian poet, writer, and artist. Built in the early 20th century, the mausoleum is situated on the Chernecha Hill in Kaniv, overlooking the Dnipro River. The structure combines elements of Ukrainian architectural styles with a grand neoclassical design. It serves as a national monument and pilgrimage site, commemorating Shevchenko's significant contributions to Ukrainian culture and literature.")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 50)
                            .padding(.horizontal)
                    }
                    .background {
                        UnevenRoundedRectangle(topLeadingRadius: 25, bottomLeadingRadius: 25, bottomTrailingRadius: 25, topTrailingRadius: 25)
                            .fill(.blue)
                    }
                    .padding()
                }
                .background(.blue)

            }
        }
    }
}

#Preview {
    ARItemScreen(selectedModel: ARModel(name: "Bosel-Mausoleum", displayName: "Модель 1", categories: [.building, .castle]))
}

struct ARViewContainer: UIViewRepresentable {
    let modelName: String

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Налаштування сесії AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)

        // Додавання 3D-моделі
        addModel(to: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func addModel(to arView: ARView) {
        // Завантаження .usdz моделі
        guard let modelEntity = try? ModelEntity.load(named: modelName) else {
            print("Не вдалося завантажити модель")
            return
        }

        // Зміна масштабу моделі для дуже малого розміру
        modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001) // Зменшити до 0.1% від оригінального розміру

        // Створення AnchorEntity на дуже малій відстані перед камерою
        let anchorEntity = AnchorEntity(world: [0, 0, -0.1]) // Розташування на 0.1 метра перед камерою

        // Додавання моделі до AnchorEntity
        anchorEntity.addChild(modelEntity)

        // Додавання якоря до сцени
        arView.scene.addAnchor(anchorEntity)
    }
}

#Preview {
    ARScreen()
}

