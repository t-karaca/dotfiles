import Wp from "gi://AstalWp";
import { App, Gtk, Astal, Widget } from "astal/gtk3";
import { AstalIO, Variable, timeout } from "astal";
import { Icons } from "./icons";
import { ProgressBar } from "./ProgressBar";

interface VolumeState {
    volume: number;
    muted: boolean;
}

function getVolumeIcon(state: VolumeState) {
    if (state.muted) {
        return Icons.volumeMuted;
    } else if (state.volume < 0.3) {
        return Icons.volumeLow;
    } else if (state.volume < 0.6) {
        return Icons.volumeMedium;
    }

    return Icons.volumeHigh;
}

const audio = Wp.get_default()!.audio;

export function OSD() {
    const state$ = Variable<VolumeState>({
        volume: audio.defaultSpeaker.volume,
        muted: audio.defaultSpeaker.mute,
    });

    let timer: AstalIO.Time | null;

    const onWindowSetup = (window: Widget.Window) => {
        window.hook(audio.defaultSpeaker, "notify", () => {
            const speaker = audio.defaultSpeaker;
            const state = state$.get();

            if (state.volume != speaker.volume || state.muted != speaker.mute) {
                state$.set({
                    volume: Math.min(speaker.volume, 1.0),
                    muted: speaker.mute,
                });

                window.visible = true;

                if (timer) {
                    timer.cancel();
                }

                timer = timeout(2000, () => {
                    window.visible = false;
                    timer = null;
                });
            }
        });
    };

    return (
        <window
            visible={false}
            name="osd-window"
            namespace="osd-window"
            className="popup-window"
            application={App}
            layer={Astal.Layer.TOP}
            anchor={Astal.WindowAnchor.BOTTOM}
            marginBottom={300}
            setup={onWindowSetup}
        >
            <box className="bg-body rounded-full px-10 py-8" widthRequest={400}>
                <icon className="osd-icon" icon={state$(getVolumeIcon)} />
                <ProgressBar
                    className={state$(s => `mx-8 ${s.muted ? "disabled" : ""}`)}
                    hexpand
                    valign={Gtk.Align.CENTER}
                    fraction={state$(s => s.volume)}
                />
                <label
                    className={state$(
                        s => `font-medium ${s.muted ? "text-gray" : ""}`,
                    )}
                    widthChars={3}
                    label={state$(s => (100 * s.volume).toFixed(0))}
                />
            </box>
        </window>
    );
}
