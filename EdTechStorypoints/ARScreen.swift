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
    case sculpture = "Sculptures"
    case artwork = "Artwork"
    case building = "Buildings"
    case castle = "Castles"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .sculpture:
            return "figure.walk" // Виберіть відповідну іконку
        case .artwork:
            return "paintbrush"
        case .building:
            return "building.2"
        case .castle:
            return "house.and.flag"
        }
    }
}


struct ARModel: Identifiable {
    let id = UUID()
    let name: String
    let displayName: String
    let categories: [ModelCategory]
}


let models: [ARModel] = [
    ARModel(name: "Bosel-Mausoleum", displayName: "Модель 1", categories: [.building, .castle]),
    ARModel(name: "gramophone", displayName: "Модель 2", categories: [.building, .sculpture]),
]

struct ARScreen: View {
    
    @State private var selectedCategory: ModelCategory = .building
    @State private var selectedModel: ARModel?
    
    @State private var isFavoritesARModelsViewButtonPressed: Bool = false
    @State private var isARShopStoreViewButtonPressed: Bool = false
    
    @State private var searchText = ""
    
    @State private var isFavoriteARModel: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                Text("Welcome to")
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                    .padding(.top, 16)
                HStack(spacing: 0) {
                    Text("AR Gallery")
                    Text("Guide")
                        .foregroundStyle(.yellow)
                }
                .font(.largeTitle)
                .bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ModelCategory.allCases) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                VStack {
                                    Image(systemName: category.icon)
                                    Text(category.rawValue)
                                        .font(.footnote)
                                }
                                .frame(minWidth : UIScreen.main.bounds.width / 4)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(selectedCategory == category ? Color.yellow : Color.white.opacity(0.1))
                                .cornerRadius(20)
                                .foregroundStyle(selectedCategory == category ? Color.black : Color.white)

                            }
                        }
                    }
                }


                if models.filter({ $0.categories.contains(selectedCategory) }).isEmpty {
                    VStack {
                        Text("Currently, there are no models in this category.")
                            .padding()
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width : UIScreen.main.bounds.width)
                } else {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(models.filter { $0.categories.contains(selectedCategory) }) { model in
                                    NavigationLink {
                                        ARItemScreen(selectedModel: model)
                                    } label: {
                                        VStack(spacing : 0) {
                                            ZStack(alignment: .top) {
                                                MiniModelView(modelName: model.name)
                                                    .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.width)
                                                    .background(
                                                        UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                                                            .fill(Color.white.opacity(0.1))
                                                    )
                                                
                                                HStack {
                                                    Image(systemName: "person")
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .font(.footnote)
                                                        .padding(10)
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.yellow)
                                                        }
                                                    VStack(alignment: .leading) {
                                                        Text("Designer Name")
                                                        Text("Location City, County")
                                                    }
                                                    .font(.footnote)
                                                    Spacer()
                                                    Image(systemName: "ellipsis")
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .foregroundStyle(.blue)
                                                        .font(.footnote)
                                                        .padding(10)
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color.yellow)
                                                        }
                                                        
                                                }
                                                .padding()
                                                .foregroundStyle(.white)
                                            }
                                            HStack(alignment: .center, spacing: 0) {
                                                Button {
                                                    isFavoriteARModel.toggle()
                                                } label: {
                                                    HStack {
                                                        Image(systemName: isFavoriteARModel ? "backpack.fill" : "backpack")

                                                        Text("256")
                                                    }
                                                    .font(.footnote)
                                                    .foregroundStyle(isFavoriteARModel ? .yellow : .primary)
                                                    .bold()
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background {
                                                        Capsule()
                                                            .fill(isFavoriteARModel ? .black : .blue)
                                                    }
                                                }
                                                HStack(spacing : 0) {
                                                    ForEach(0..<2){_ in
                                                        Image(systemName: "rosette")
                                                    }
                                                }
                                                .padding(.leading, 8)
                                                Spacer()
                                                Image(systemName: "square.and.arrow.up.fill")
                                            }
                                            .padding()
                                            .background(
                                                UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                                                    .fill(Color.white.opacity(0.1))
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("ARCollection")
                            .foregroundStyle(.accent)
                            .font(.largeTitle)
                    } footer: {
                        Text("All your AR model collection will be stored here. As you open chests or progress through levels, new models will gradually be added or unlocked.")
                            .foregroundStyle(.primary)
                            .font(.footnote)
                        
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .configureNavigationBar()
        .padding(.leading)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ARGallery")
        .searchable(text: $searchText, prompt: "Search AR Object")
        .toolbar {
            leadingNavItems()
            trailingNavItems()
        }
    }
}

extension ARScreen {

    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            trailingNavView()
        }
    }


    @ViewBuilder
    private func leadingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                isFavoritesARModelsViewButtonPressed.toggle()
            }
        } label: {
            Image(systemName: isFavoritesARModelsViewButtonPressed ? "backpack.fill" : "backpack")
                .foregroundStyle(isFavoritesARModelsViewButtonPressed ? .blue : .white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Profile View Button")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
    

    @ViewBuilder
    private func trailingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                isARShopStoreViewButtonPressed.toggle()
            }
        } label: {
            Image(systemName: isARShopStoreViewButtonPressed ? "cart.fill" : "cart")
                .foregroundStyle(isARShopStoreViewButtonPressed ? .blue : .white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Apple Watch")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
    
    private struct NavigationBarConstants {
        let leadingSpacing: CGFloat = 6
        let leadingDefaultSpacing: CGFloat = 0
        let leadingSmallestFont: CGFloat = 12
        let leadingLargestFont: CGFloat = 14
        
        let trailingCornerRadius: CGFloat = 8
        let trailingImageWidth: CGFloat = 24
        let trailingImageHeight: CGFloat = 24
        let trailingStackWidth: CGFloat = 40
        let trailingStackHeight: CGFloat = 40
    }
}


struct ARItemScreen: View {
    @State private var showARView = false
    let selectedModel : ARModel?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowAudioPlayer: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    MiniModelView(modelName: selectedModel?.name ?? "")
                        .frame(height: 400)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding()
                    VStack {
                        HStack {
                            Button {
                                isShowAudioPlayer.toggle()
                            } label: {
                                Label("Play", systemImage: "headphones")
                                    .padding(15)
                                    .foregroundStyle(.blue)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.yellow)
                                    }
                                
                            }
                            .padding(.horizontal)
                            .offset(y: -20)
                            .sheet(isPresented: $isShowAudioPlayer) {
                                Text("Player")
                                    .presentationDetents([.medium])
                            }
                            Spacer()
                            Button {
                                showARView.toggle()
                            } label: {
                                Label("Go", systemImage: "arkit")
                                    .padding(15)
                                    .foregroundStyle(.blue)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.yellow)
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
                            .fill(.white.opacity(0.1))
                    }
                    .padding()
                }
            }
            .configureNavigationBar()
            .navigationTitle("Model Name")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                leadingNavItems()
            }
            .background(ComplexAnimatedGradient())
        }
    }
}

#Preview {
    ARItemScreen(selectedModel: ARModel(name: "Bosel-Mausoleum", displayName: "Модель 1", categories: [.building, .castle]))
}


extension ARItemScreen {
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }
    
    @ViewBuilder
    private func leadingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Back Button to ARScreen")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
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

