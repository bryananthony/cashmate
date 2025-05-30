
import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Info")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.headline)
                            Text("Gwyneth (Gya)")
                                .font(.subheadline)
                        }
                    }
                }

                Section(header: Text("About")) {
                    Text("An aspiring entrepreneur studying at UC. Passionate about managing money wisely and building a strong financial future.")
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
