import SwiftUI
import Kingfisher

struct UserListUI: View {
    
    @EnvironmentObject var router: RouterUserInfo
    @StateObject var viewModel = UserListViewModel()
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: Height.smallHeight) {
                VStack {
                    KFImage.profile(urlString: viewModel.user.profileImageUrl, size: Height.xLargeHeight)
                    
                    Text(viewModel.user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, Height.smallHeight)
                Spacer()
                // Menü Grupları
                VStack(spacing: Height.xSmallHeight) {
                    MenuSection(items: [
                        MenuItem(icon: Icons.person, title: StringKey.personal_info,onClick:{ router.navigate(to: .userInfo)}),
                    ])
                    
                    MenuSection(items: [
                        MenuItem(icon: "questionmark.circle.fill", title: StringKey.change_password,onClick:{ router.navigate(to: .resetPassword)}),
                        MenuItem(icon: "star.fill", title: StringKey.notifications,onClick:{ router.navigate(to: .userInfo)}),
                        MenuItem(icon: "gearshape.fill", title: StringKey.settings,onClick:{ router.navigate(to: .userInfo)})
                    ])
                    Spacer()
                    MenuSection(items: [
                        MenuItem(icon: "arrow.left.square.fill", title: StringKey.log_out,onClick:{ viewModel.signOut()
                        }),
                    ])
                }
                .padding()
            }
        }.onAppear {
            viewModel.fetchProfile()
        }
    }
}

// Menü İçin Yardımcı Yapılar
struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: LocalizedStringKey
    let onClick: () -> Void
}

struct MenuSection: View {
    let items: [MenuItem]
    
    var body: some View {
        VStack {
            ForEach(items) { item in
                MenuItemView(icon: item.icon, title: item.title, onClick: item.onClick)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(Radius.mediumRadius)
    }
}

struct MenuItemView: View {
    let icon: String
    let title: LocalizedStringKey
    var onClick: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue500)
                .frame(width: 24)
            
            tvColorKey(text: title, color: .black, font: .body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }.onTapGesture {
            onClick()
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserListUI(userManager: UserManager())
    }
}
