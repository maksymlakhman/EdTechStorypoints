import SwiftUI

struct AIAssistantButton: View {
    @State private var isExpanded = false
    @State private var rotation: CGFloat = 0.0
    let buttons: [ArcMenuButtonName]
    @EnvironmentObject var viewModel: GameViewModel
    var ontap: (ArcMenuButtonName) -> Void

    var body: some View {
        ZStack {
            ForEach(buttons, id: \.self) { button in
                Image(button.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(8)
                    .background(viewModel.activeButtons.contains(button) ? Color.blue : Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .offset(
                        x: isExpanded ? CGFloat(cos((Double(buttons.firstIndex(of: button)!) * 310) * Double.pi / 180) * -60) : 0,
                        y: isExpanded ? CGFloat(sin((Double(buttons.firstIndex(of: button)!) * 310) * Double.pi / 180) * -60) : 0
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0).delay(Double(buttons.firstIndex(of: button)!) * 0.15), value: isExpanded)
                    .onTapGesture {
                        ontap(button)
                    }
            }
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .frame(height: 50)
                        .foregroundStyle(.blue.opacity(0.5))
                    
                    Circle()
                        .frame(height: 50)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.8), .purple, .teal, .pink.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.degrees(rotation))
                        .mask {
                            Circle()
                                .strokeBorder(lineWidth: 1)
                                .frame(height: 50)
                        }
                    Image(systemName: isExpanded ? "xmark" : "brain.head.profile.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(15)
                        .background(.blue)
                        .cornerRadius(25)
                }
            }
        }
    }
}

enum ArcMenuButtonName: String {
    case cossackLarge = "CossackLarge"
    case cossackLong = "CossackLong"
    case cossackSmall = "CossackSmall"
    
    static var allCases: [ArcMenuButtonName] {
        return [.cossackLarge, .cossackLong, .cossackSmall]
    }
}

// Use like this
struct ArcMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AIAssistantButton(buttons: Array(ArcMenuButtonName.allCases)) { button in
                switch button {
                case .cossackLarge:
                    print("cossackLarge button tapped.")
                case .cossackLong:
                    print("cossackLong button tapped.")
                case .cossackSmall:
                    print("CossackSmall button tapped.")
                }
            }
            .hAlign(.trailing)
            .vAlign(.top)
            .padding()
        }
        .environmentObject(GameViewModel())
    }
}
