//
//  AlertView.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import SwiftUI

enum AlertType: String {
    case info = "Info!"
    case error = "Error!"
    case warning = "Warning!"
    case delete = "Delete!"
    case done = "Done!"
    case empty = "Empty!"
    
    var icon: Image {
        switch self {
        case .info:
            return Image(systemName: Images.info)
        case .error:
            return Image(systemName: Images.error)
        case .warning:
            return Image(systemName: Images.warning)
        case .delete:
            return Image(systemName: Images.delete)
        case .done:
            return Image(systemName: Images.done)
        case .empty:
            return Image(systemName: Images.empty)
        }
    }
}

struct AlertButtons {
    var confirmTitle: String
    var cancelTitle: String
    var showCancel: Bool
    
    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?
    
    init(confirmTitle: String = "Confirm",
         cancelTitle: String = "Khalli Walli",
         showCancel: Bool = false,
         onConfirm: (() -> Void)? = nil,
         onCancel: (() -> Void)? = nil) {
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.showCancel = showCancel
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }
}

struct AlertConfig {
    var message: String
    var buttons: AlertButtons?
    var alertType: AlertType

    init(alertType: AlertType = .error,
         message: String = "Had a little brain freeze while thinking.\nPlease try again later.",
         buttons: AlertButtons? = nil) {
        self.alertType = alertType
        self.message = message
        self.buttons = buttons
    }
}

struct AlertView: View {
    @State private var isAnimated = false
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()
    var config: AlertConfig
    init(config: AlertConfig = AlertConfig()) {
        self.config = config
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 16) {
                titleView()
                if let buttons = config.buttons {
                    buttonsView(buttons: buttons)
                        .padding(.vertical)
                }
            }
            .multilineTextAlignment(.center)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .primary.opacity(0.4),radius: 12)
            )
            .padding()
        }
        .ignoresSafeArea(.all)
        .onReceive(timer) { _ in
            withAnimation {
                isAnimated.toggle()
            }
        }
    }
    
    func titleView() -> some View {
        VStack {
            config.alertType.icon
                .resizable()
                .frame(width: isAnimated ? 100 : 60,
                       height: isAnimated ? 100 : 60)
                .foregroundStyle(Color.purple)
            Text(config.alertType.rawValue)
                .font(AppTypography.title(size: 24))
            if config.alertType == .empty {
                Text("There is nothing to show yet.\nWill be back soon.")
                    .font(AppTypography.body(size: 16))
            } else {
                Text(config.message)
                    .font(AppTypography.body(size: 16))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func buttonsView(buttons: AlertButtons) -> some View {
        VStack {
            HStack(spacing: 16) {
                if buttons.showCancel {
                    Button {
                        buttons.onCancel?()
                    } label: {
                        Text(buttons.cancelTitle)
                            .font(AppTypography.body(size: 18))
                            .frame(height: 28)
                            .foregroundStyle(Color.accentColor)
                    }
                    .buttonStyle(RoundedBorderButtonStyle(backgroundColor: Color(uiColor: .systemBackground),
                                                          borderColor: .accentColor,
                                                         cornerRadius: 28))
                }
                Button {
                    buttons.onConfirm?()
                } label: {
                    Text(buttons.confirmTitle)
                        .font(AppTypography.body(size: 18))
                        .frame(height: 28)
                }
                .buttonStyle(RoundedBorderButtonStyle())
            }
        }
    }
}

#Preview {
    AlertView()
}
