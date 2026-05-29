// MobSignaturePadView — tier-2 demo plugin's SwiftUI view.
//
// Two pieces:
//   1. MobSignaturePadView — the SwiftUI view body.
//   2. MobDemoSignaturePadPlugin — an Objective-C-visible class with a
//      class method the host (or a future mob_dev codegen step) can call
//      from AppDelegate.didFinishLaunchingWithOptions, before mob_init_ui,
//      to register the view factory with MobNativeViewRegistry.shared.
//
// The registry key matches the manifest's ui_components.ios.view_module
// (`"MobDemoSignaturePad_View"`) and what Mob.Component.module_name/1
// emits at render time as the node's `:module` prop.
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

@objc public class MobDemoSignaturePadPlugin: NSObject {
    @objc public class func mob_register() {
        MobNativeViewRegistry.shared.register("MobDemoSignaturePad_View") { props, _send in
            AnyView(MobSignaturePadView(props: props))
        }
    }
}
