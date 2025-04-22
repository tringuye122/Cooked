//
//  app_logo.swift
//  Cooked!
//
//  Created by Tri Nguyen on 4/22/25.
//

import SwiftUI

struct app_logo: View {
    var body: some View {
        Image(systemName: "fork.knife.circle.fill")
            .font(.system(size: 80))
            .foregroundStyle(.black)
    }
}

#Preview {
    app_logo()
}
