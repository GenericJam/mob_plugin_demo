// MobSignaturePad — tier-2 demo plugin's Compose component.
//
// Until the plugin merge engine ships plugin Kotlin into the build
// automatically, the HOST APP copies this content into its MobBridge.kt
// (or adds this file to a sourceSet that gradle compiles) AND ensures
// MobSignaturePadPlugin.register() runs at startup — the documented
// workflow for native components today.
//
// The actual UI is a no-op placeholder: a rounded rectangle reading
// `bg_color` and `corner_radius` from props. Focus is on the registration
// + dispatch path, not the rendered content.

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

object MobSignaturePadPlugin {
    fun register() {
        MobNativeViewRegistry.register("MobDemoSignaturePad_View") { props, _send ->
            SignaturePad(props)
        }
    }
}

@Composable
private fun SignaturePad(props: Map<String, Any?>) {
    val bg = (props["bg_color"] as? String) ?: "#3366cc"
    val radius = (props["corner_radius"] as? Number)?.toFloat() ?: 12f

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(160.dp)
            .clip(RoundedCornerShape(radius.dp))
            .background(parseHexColor(bg))
    )
}

private fun parseHexColor(s: String): Color {
    val h = s.removePrefix("#")
    return if (h.length == 6) {
        Color(
            h.substring(0, 2).toInt(16),
            h.substring(2, 4).toInt(16),
            h.substring(4, 6).toInt(16)
        )
    } else Color.Gray
}
