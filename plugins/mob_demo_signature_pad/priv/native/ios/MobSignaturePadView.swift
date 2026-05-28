// MobSignaturePadView — tier-2 demo plugin's SwiftUI view.
//
// iOS-side placeholder. Tier-2 iOS integration follows the same pattern as
// Android — host wires this into the project's existing native_view dispatch
// (or a future merge-engine slice automates it). Mob's iOS render pipeline
// already routes native_view nodes via the `module` prop (see ios/mob_nif.m
// `MobNodeTypeNativeView`).
import SwiftUI

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
