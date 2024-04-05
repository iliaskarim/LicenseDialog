// LICENSE DIALOG
// Copyright (C) 2024  Ilias Karim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
import SwiftUI

private extension Image {
  static let xmark: Self = .init(systemName: "xmark")
}

private extension LocalizedStringKey {
  static let sourceCode: Self = "source_code"
}

/// License dialog
public struct LicenseDialog: View {
  @Environment(\.dismiss) private var dismiss
  @State private var isLoading = true
  private let license: License
  private let sourceCodeURL: URL

  /// Designated initializer
  /// - Parameters:
  ///   - license: License
  ///   - sourceCodeURL: Source code URL
  public init(license: License, sourceCodeURL: URL) {
    self.license = license
    self.sourceCodeURL = sourceCodeURL
  }

  public var body: some View {
    NavigationView {
      LicenseView(license: license.url, isLoading: $isLoading)
        .overlay {
          ProgressView().opacity(isLoading ? 1.0 : 0.0)
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              dismiss()
            } label: {
              Image.xmark
            }
          }

          ToolbarItem(placement: .bottomBar) {
            Button {
              UIApplication.shared.open(sourceCodeURL)
              dismiss()
            } label: {
              Text(.sourceCode, bundle: .module)
            }
          }
        }
    }
  }
}

#Preview {
  LicenseDialog(license: .gpl, sourceCodeURL: .init(string: "https://github.com/iliaskarim/LicenseDialog")!)
}

#Preview {
  LicenseDialog(license: .lgpl, sourceCodeURL: .init(string: "https://github.com/iliaskarim/LicenseDialog")!)
}

