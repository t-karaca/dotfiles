import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { Variable } from "astal";
import Apps from "gi://AstalApps";
import { Icons } from "./icons";
import { Entry } from "astal/gtk3/widget";

const MAX_ITEMS = 6;

function createAppItem({
    className,
    onSelected,
    onFocused,
}: {
    className?: string;
    onSelected: (app: Apps.Application) => void;
    onFocused?: () => void;
}) {
    const app$ = Variable<Apps.Application | null>(null);

    const select = () => {
        const app = app$.get();

        if (app) {
            onSelected(app);
        }
    };

    const getApplication = () => app$.get();

    const setApplication = (app: Apps.Application | null) => {
        app$.set(app);
    };

    const onKeyPress = (_: any, e: Gdk.Event) => {
        if (e.get_keyval()[1] === Gdk.KEY_Return) {
            select();
        }
    };

    const widget = (
        <button
            visible={app$(a => !!a)}
            className={`action-list__item ${className}`}
            onClicked={select}
            onKeyPressEvent={onKeyPress}
            setup={b => {
                b.add_events(Gdk.EventMask.POINTER_MOTION_MASK);
                b.connect("motion-notify-event", () => b.grab_focus());

                if (onFocused) {
                    b.connect("grab-focus", onFocused);
                }
            }}
        >
            <box>
                <icon
                    className="launcher-icon mr-6"
                    icon={app$(a => a?.iconName || Icons.executable)}
                />
                <box vertical hexpand valign={Gtk.Align.CENTER}>
                    <label
                        label={app$(a => a?.name || "")}
                        hexpand
                        valign={Gtk.Align.CENTER}
                        xalign={0}
                        truncate
                    />
                    <label
                        visible={app$(a => !!a?.description)}
                        className="font-lg text-white-75"
                        label={app$(a => a?.description || "")}
                        hexpand
                        maxWidthChars={30}
                        justify={Gtk.Justification.LEFT}
                        valign={Gtk.Align.CENTER}
                        xalign={0}
                        truncate
                        wrap
                    />
                </box>
            </box>
        </button>
    );

    return {
        widget,
        select,
        getApplication,
        setApplication,
    };
}

type AppItem = ReturnType<typeof createAppItem>;

export function Launcher() {
    const apps = new Apps.Apps({});

    const appItems: AppItem[] = [];

    let window: Gtk.Window;
    let entry: Gtk.Entry;
    let currentEntryIndex = -1;
    let entryCount = 0;

    const appList = Variable<Apps.Application[]>([]);

    for (let i = 0; i < MAX_ITEMS; i++) {
        appItems.push(
            createAppItem({
                onSelected: app => {
                    app.launch();

                    window.visible = false;
                },
                onFocused: () => {
                    currentEntryIndex = i;
                },
            }),
        );
    }

    let launcherClicked = false;

    const onWindowShow = () => {
        entry.text = "";
        entry.set_position(-1);
        entry.select_region(0, -1);
        entry.grab_focus();

        currentEntryIndex = -1;
        entryCount = 0;

        // const queriedApps = apps.fuzzy_query(entry.text).slice(0, MAX_ITEMS);
        // appList.set(queriedApps);
        //
        // for (let i = 0; i < MAX_ITEMS; i++) {
        //     const app = i < queriedApps.length ? queriedApps[i] : null;
        //     appItems[i].setApplication(app);
        // }

        for (let i = 0; i < MAX_ITEMS; i++) {
            appItems[i].setApplication(null);
        }
    };

    const onWindowHide = () => apps.reload();
    const onWindowSetup = (w: Gtk.Window) => {
        window = w;

        window.add_events(Gdk.EventMask.FOCUS_CHANGE_MASK);

        window.connect("focus-out-event", () => {
            window.visible = false;
        });

        window.connect("show", onWindowShow);
        window.connect("hide", onWindowHide);
    };

    const onWindowButtonPress = (window: Gtk.Window) => {
        if (!launcherClicked) {
            window.visible = false;
        }

        launcherClicked = false;
    };

    const onWindowKeyPress = (window: Gtk.Window, event: Gdk.Event) => {
        const key = event.get_keyval()[1];
        const hasCtrlModifier = !!(
            event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK
        );

        const unicode = Gdk.keyval_to_unicode(key);

        if (key == Gdk.KEY_Escape || (key == Gdk.KEY_c && hasCtrlModifier)) {
            window.visible = false;
        } else if (hasCtrlModifier && key == Gdk.KEY_j) {
            if (currentEntryIndex < entryCount - 1) {
                appItems[currentEntryIndex + 1].widget.grab_focus();
            }
        } else if (hasCtrlModifier && key == Gdk.KEY_k) {
            if (currentEntryIndex === 0) {
                currentEntryIndex = -1;
                entry.grab_focus();
                entry.select_region(entry.text.length, -1);
            } else if (currentEntryIndex > 0) {
                appItems[currentEntryIndex - 1].widget.grab_focus();
            }
        } else if (
            !entry.has_focus &&
            unicode != 0 &&
            key !== Gdk.KEY_Tab &&
            key !== Gdk.KEY_space &&
            key !== Gdk.KEY_Return
        ) {
            entry.grab_focus();
            entry.select_region(entry.text.length, -1);
        }
    };

    const onEntrySetup = (e: Entry) => {
        entry = e;

        e.connect("grab-focus", () => {
            currentEntryIndex = -1;
        });
    };

    const onEntryChanged = () => {
        const queriedApps = apps.fuzzy_query(entry.text).slice(0, MAX_ITEMS);
        appList.set(queriedApps);

        entryCount = queriedApps.length;

        for (let i = 0; i < MAX_ITEMS; i++) {
            const app = i < queriedApps.length ? queriedApps[i] : null;
            appItems[i].setApplication(app);
        }
    };

    const onEntryActivate = () => {
        const apps = appList.get();
        if (apps.length > 0) {
            apps[0].launch();

            window.visible = false;
        }
    };

    return (
        <window
            name="launcher"
            namespace="launcher"
            application={App}
            visible={false}
            className="popup-window"
            layer={Astal.Layer.TOP}
            keymode={Astal.Keymode.ON_DEMAND}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            setup={onWindowSetup}
            onButtonPressEvent={onWindowButtonPress}
            onKeyPressEvent={onWindowKeyPress}
        >
            <centerbox vexpand hexpand>
                <box />
                <box vertical>
                    <eventbox
                        onButtonPressEvent={() => (launcherClicked = true)}
                    >
                        <box
                            className="bg-body rounded-xl action-list action-list--rounded-last"
                            valign={Gtk.Align.START}
                            vertical
                            vexpand={false}
                            widthRequest={750}
                            marginTop={200}
                        >
                            <entry
                                className="font-2xl bg-transparent py-8 px-10 shadow-none"
                                hexpand={true}
                                placeholderText="Search"
                                setup={onEntrySetup}
                                onChanged={onEntryChanged}
                                onActivate={onEntryActivate}
                            />
                            {appItems.map(appItem => appItem.widget)}
                        </box>
                    </eventbox>
                </box>
                <box />
            </centerbox>
        </window>
    );
}
