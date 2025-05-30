//
//  ContentView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Header
            HStack {
                Image(systemName: "plus")
                    .font(.title)
                    .padding(.leading)
                
                Spacer()
                
                Text("14 Mei 2022")
                    .foregroundColor(.blue)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.trailing)
            }
            .padding(.top)
            
            Divider()
            
            // Logo & Title
            VStack(spacing: 16) {
                Image(systemName: "wallet.pass.fill") // Simbol pengganti
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .background(Circle().fill(Color.blue).frame(width: 120, height: 120))
                
                Text("Cashmate")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, 40)
            
            // Welcome Text
            Text("WELCOME!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .padding(.top, 20)
            
            // Info Text
            VStack(spacing: 4) {
                Text("You don't have any transaction yet")
                Text("Please Add Transaction")
            }
            .font(.body)
            .padding(.top, 8)
            
            // Button
            Button(action: {
                // Aksi tambah transaksi
            }) {
                Text("+Tambah Transaksi")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .cornerRadius(12)
                    .padding(.horizontal, 30)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Tab Bar
            HStack {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Beranda")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Transaksi")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Image(systemName: "gearshape.fill")
                    Text("Pengaturan")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .padding(.bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
