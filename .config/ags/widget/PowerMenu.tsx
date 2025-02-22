import { App, Gtk, Astal, Gdk } from "astal/gtk3";
import { execAsync } from "astal";
import { Button } from "astal/gtk3/widget";
import { Icons } from "./icons";

const entries = [
    {
        label: "Suspend",
        icon: Icons.systemSuspend,
        onSelected: () => execAsync("systemctl suspend"),
    },
    {
        label: "Lock",
        icon: Icons.systemLock,
        onSelected: () => execAsync("loginctl lock-session"),
    },
    {
        label: "Shutdown",
        icon: Icons.systemShutdown,
        onSelected: () => execAsync("systemctl poweroff"),
    },
    {
        label: "Reboot",
        icon: Icons.systemReboot,
        onSelected: () => execAsync("systemctl reboot"),
    },
    {
        label: "Logout",
        icon: Icons.systemLogout,
        onSelected: () => execAsync("hyprctl dispatch exit"),
    },
];

function PowerMenuItem({
    className,
    icon,
    label,
    onSelected,
    setup,
    onFocused,
}: {
    className?: string;
    icon: string;
    label: string;
    onSelected?: () => void;
    setup?: (button: Button) => void;
    onFocused?: () => void;
}) {
    return (
        <button
            className={`action-list__item ${className}`}
            onClicked={onSelected}
            setup={b => {
                b.add_events(Gdk.EventMask.POINTER_MOTION_MASK);

                b.connect("motion-notify-event", () => b.grab_focus());

                if (onFocused) {
                    b.connect("grab-focus", onFocused);
                }

                if (setup) {
                    setup(b);
                }
            }}
        >
            <box>
                <icon icon={icon} className="font-2xl mr-8" />
                <label label={label} />
            </box>
        </button>
    );
}

export function PowerMenu() {
    let window: Gtk.Window;
    const bgWindows = new Array<Gtk.Window>();

    const entryWidgets = new Array<Button>(entries.length);

    let currentEntryIndex = 0;

    const onBgWindowSetup = (w: Gtk.Window) => {
        bgWindows.push(w);
    };

    const onWindowSetup = (w: Gtk.Window) => {
        window = w;
        window.add_events(Gdk.EventMask.FOCUS_CHANGE_MASK);

        window.connect("focus-out-event", () => {
            window.visible = false;
        });

        window.connect("show", () => {
            bgWindows.forEach(bgWindow => (bgWindow.visible = true));
            entryWidgets[0].grab_focus();
        });

        window.connect("hide", () => {
            bgWindows.forEach(bgWindow => (bgWindow.visible = false));
        });
    };

    const onBgWindowButtonPress = () => {
        window.visible = false;
    };

    const onWindowKeyPress = (window: Gtk.Window, event: Gdk.Event) => {
        const key = event.get_keyval()[1];
        const hasCtrlModifier = !!(
            event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK
        );

        if (key == Gdk.KEY_Escape || (key == Gdk.KEY_c && hasCtrlModifier)) {
            window.visible = false;
        }

        if (hasCtrlModifier && key == Gdk.KEY_j) {
            if (currentEntryIndex < entryWidgets.length - 1) {
                entryWidgets[currentEntryIndex + 1].grab_focus();
            }
        }

        if (hasCtrlModifier && key == Gdk.KEY_k) {
            if (currentEntryIndex > 0) {
                entryWidgets[currentEntryIndex - 1].grab_focus();
            }
        }
    };

    App.get_monitors().map(monitor => (
        <window
            visible={false}
            gdkmonitor={monitor}
            namespace="background-layer"
            className="bg-black-50"
            layer={Astal.Layer.TOP}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            marginTop={-40}
            setup={onBgWindowSetup}
            onButtonPressEvent={onBgWindowButtonPress}
        />
    ));

    return (
        <window
            visible={false}
            name="powermenu"
            namespace="powermenu"
            className="popup-window"
            application={App}
            layer={Astal.Layer.OVERLAY}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            keymode={Astal.Keymode.ON_DEMAND}
            setup={onWindowSetup}
            onKeyPressEvent={onWindowKeyPress}
            marginTop={-40}
        >
            <box
                className="bg-body rounded-xl action-list action-list--rounded-first action-list--rounded-last"
                valign={Gtk.Align.START}
                vertical
                vexpand={false}
                widthRequest={400}
            >
                {entries.map((entry, index) => (
                    <PowerMenuItem
                        className="py-6 px-8"
                        icon={entry.icon}
                        label={entry.label}
                        onSelected={() => {
                            setTimeout(() => entry.onSelected(), 1000);
                            window.visible = false;
                        }}
                        onFocused={() => {
                            currentEntryIndex = index;
                        }}
                        setup={b => (entryWidgets[index] = b)}
                    />
                ))}
            </box>
        </window>
    );
}
