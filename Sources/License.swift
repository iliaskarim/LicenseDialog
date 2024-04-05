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
import Foundation

public enum License: String {
  case gpl
  case lgpl
}

extension License {
  var url: URL! {
    let basename: String
    switch self {
    case .gpl:
      basename = "GNU General Public License v3.0"
    case .lgpl:
      basename = "GNU Lesser General Public License v3.0"
    }
    return Bundle.module.url(forResource: basename, withExtension: "html")
  }
}
