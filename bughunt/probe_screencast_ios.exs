# iOS on-device screencast frame-flow verify (physical iPhone over WiFi dist).
# Runs a collector ON the phone via Code.eval_string (frames go to the calling
# process, and a local anon fn can't be spawned across dist). ReplayKit pops a
# consent dialog on the phone — someone must tap Allow within the window.
# Usage: elixir --name probe@<mac-ip> --cookie mob_secret bughunt/probe_screencast_ios.exs <phone-ip>
phone_ip = System.argv() |> List.first() || "10.0.0.120"
target = :"mob_plugin_demo_ios@#{phone_ip}"

true = Node.connect(target) || raise "cannot connect #{target}"
IO.puts("connected to #{target}; starting 20s collect (watch the phone for the consent dialog)")

code = ~S"""
:mob_screencast_nif.screencast_start_stream(
  :json.encode(%{"bitrate" => 2_000_000, "fps" => 30, "keyframe_interval_ms" => 2000, "max_size" => 640})
)

deadline = System.monotonic_time(:millisecond) + 20_000

collect = fn collect, acc ->
  remaining = deadline - System.monotonic_time(:millisecond)

  if remaining <= 0 do
    acc
  else
    receive do
      {:screencast, :frame, f} ->
        collect.(collect, [
          %{
            kind: :frame,
            format: f[:format],
            width: f[:width],
            height: f[:height],
            keyframe: f[:keyframe],
            bytes: byte_size(f[:bytes]),
            annexb: match?(<<0, 0, 0, 1, _::binary>>, f[:bytes])
          }
          | acc
        ])

      {:screencast, :permission, p} ->
        collect.(collect, [{:permission, p} | acc])

      other ->
        collect.(collect, [{:other, other} | acc])
    after
      remaining -> acc
    end
  end
end

events = collect.(collect, []) |> Enum.reverse()
:mob_screencast_nif.screencast_stop_stream()

frames = for %{kind: :frame} = f <- events, do: f

%{
  total_events: length(events),
  frames: length(frames),
  keyframes: Enum.count(frames, & &1.keyframe),
  non_frame_events: Enum.reject(events, &match?(%{kind: :frame}, &1)) |> Enum.take(5),
  first_frame: List.first(frames),
  all_annexb: frames != [] and Enum.all?(frames, & &1.annexb),
  dims: frames |> Enum.map(&{&1.width, &1.height}) |> Enum.uniq(),
  total_bytes: frames |> Enum.map(& &1.bytes) |> Enum.sum()
}
"""

case :rpc.call(target, Code, :eval_string, [code], 30_000) do
  {summary, _bindings} -> IO.inspect(summary, label: "screencast summary")
  other -> IO.inspect(other, label: "rpc error")
end
