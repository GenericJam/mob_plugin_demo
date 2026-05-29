// MobSignaturePadView — tier-2 demo plugin's SwiftUI view.
//
// Ships only the SwiftUI struct. Registration with
// MobNativeViewRegistry.shared is handled by the build-time-generated
// `mob_register_plugins()` function (see MobDev.Plugin.IOSBootstrap),
// which AppDelegate.m calls before mob_init_ui(). The codegen reads the
// plugin's manifest to know:
//
//   * which registry key to register under
//     (`ui_components.ios.view_module` — must match what
//     Mob.Component.module_name/1 emits as the node's `:module` prop)
//   * which Swift struct to instantiate
//     (`ui_components.ios.swift_struct` — this file's `MobSignaturePadView`)
//
// Pre-codegen this file also exported an @objc class with a `mob_register`
// classmethod the host called by hand; that's gone now.
import SwiftUI
import Foundation

struct MobSignaturePadView: View {
    let props: [String: Any]

    var body: some View {
        let bg = props["bg_color"] as? String ?? "#3366cc"
        let radius = (props["corner_radius"] as? Double) ?? 12.0

        RoundedRectangle(cornerRadius: radius)
            .fill(parseHexColor(bg))
            .frame(height: 160)
    }

    private func parseHexColor(_ s: String) -> Color {
        let h = s.hasPrefix("#") ? String(s.dropFirst()) : s
        guard h.count == 6, let v = UInt32(h, radix: 16) else { return .gray }
        let r = Double((v >> 16) & 0xff) / 255.0
        let g = Double((v >> 8) & 0xff) / 255.0
        let b = Double(v & 0xff) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}
