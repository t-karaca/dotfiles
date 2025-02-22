import { Gtk, Astal } from "astal/gtk3";
import { Variable } from "astal";
import Notifd from "gi://AstalNotifd";
import { Icons } from "./icons";

const notifd = Notifd.get_default();

function createNotificationPopup({
    id,
    spacing,
    onDestroy,
}: {
    id: number;
    spacing: number;
    onDestroy?: () => void;
}) {
    const notification$ = Variable(notifd.get_notification(id));
    const spacing$ = Variable(spacing);

    let window: Gtk.Window;

    let isDestroyed = false;

    const destroy = () => {
        if (!isDestroyed) {
            isDestroyed = true;

            window.destroy();

            if (onDestroy) {
                onDestroy();
            }
        }
    };

    if (notification$.get().expireTimeout !== 0) {
        setTimeout(
            destroy,
            notification$.get().expireTimeout > 0
                ? notification$.get().expireTimeout
                : 5000,
        );
    }

    const dismiss = () => notification$.get().dismiss();
    const getHeight = () => window.get_allocated_height();
    const update = () => notification$.set(notifd.get_notification(id));
    const setSpacing = (spacing: number) => spacing$.set(spacing);

    const onNotificationClick = () => {
        const notification = notification$.get();
        const actions = notification.get_actions();

        if (actions.length > 0) {
            notification.invoke(actions[0].id);
        } else {
            dismiss();
        }
    };

    const onCloseClick = () => dismiss();

    window = (
        <window
            visible={true}
            name="notifications"
            namespace="notifications"
            layer={Astal.Layer.OVERLAY}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
            marginTop={spacing$(m => m + 30)}
            marginRight={30}
            className="notifications-window"
            widthRequest={450}
        >
            <eventbox onClick={onNotificationClick}>
                <box className="bg-body rounded-xl py-5 px-6">
                    <icon
                        visible={notification$(
                            n =>
                                n.appName !== "grimblast" &&
                                n.appName !== "Hyprshot",
                        )}
                        className="font-4xl mr-4"
                        icon={notification$(
                            n => n.image || n.appIcon || Icons.dialogInfo,
                        )}
                        valign={Gtk.Align.START}
                    />
                    <box vertical valign={Gtk.Align.START}>
                        <box hexpand>
                            <label
                                hexpand
                                xalign={0}
                                valign={Gtk.Align.START}
                                className="font-xl font-medium"
                                label={notification$(n => n.summary)}
                                truncate
                            />
                            <button
                                className="ml-5 btn-close"
                                onClick={onCloseClick}
                            >
                                <icon icon={Icons.windowClose} />
                            </button>
                        </box>
                        <label
                            visible={notification$(
                                n => !!n.body && n.body.length > 0,
                            )}
                            hexpand
                            xalign={0}
                            className="text-gray mt-1"
                            label={notification$(n => n.body)}
                            wrap
                        />
                        <icon
                            hexpand
                            className="notification-screenshot-image"
                            visible={notification$(
                                n =>
                                    n.appName === "grimblast" ||
                                    n.appName === "Hyprshot",
                            )}
                            icon={notification$(
                                n => n.image || n.appIcon || Icons.dialogInfo,
                            )}
                        />
                        <box
                            visible={notification$(
                                n => n.get_actions().length > 1,
                            )}
                            spacing={10}
                            marginTop={10}
                        >
                            {notification$(n =>
                                n
                                    .get_actions()
                                    .map(action => (
                                        <button
                                            label={action.label}
                                            onClick={() => n.invoke(action.id)}
                                        />
                                    )),
                            )}
                        </box>
                    </box>
                </box>
            </eventbox>
        </window>
    ) as Gtk.Window;

    return {
        id,
        window,
        getHeight,
        update,
        destroy,
        setSpacing,
        dismiss,
    };
}

type NotificationPopup = ReturnType<typeof createNotificationPopup>;

export function Notifications() {
    const openNotifications: NotificationPopup[] = [];

    const findIndexById = (id: number) =>
        openNotifications.findIndex(p => p.id == id);

    const findById = (id: number) => {
        const index = findIndexById(id);

        if (index > -1) {
            return openNotifications[index];
        }

        return undefined;
    };

    const updateSpacings = () => {
        let margin = 0;

        for (let i = 0; i < openNotifications.length; i++) {
            const n = openNotifications[i];

            if (i > 0) {
                const prev = openNotifications[i - 1];
                margin += 10 + prev.getHeight();
            }

            n.setSpacing(margin);
        }
    };

    notifd.connect("notified", (_, id) => {
        if (!id) {
            return;
        }

        const index = openNotifications.findIndex(p => p.id === id);

        if (index == -1) {
            let margin = 0;

            for (const p of openNotifications) {
                margin += p.getHeight() + 10;
            }

            const popup = createNotificationPopup({
                id,
                spacing: margin,
                onDestroy: () => {
                    const index = openNotifications.findIndex(p => p.id === id);

                    if (index == -1) {
                        return;
                    }

                    openNotifications.splice(index, 1);

                    updateSpacings();
                },
            });

            openNotifications.push(popup);
        } else {
            openNotifications[index].update();
        }
    });

    notifd.connect("resolved", (_, id, reason) => {
        if (!id) {
            return;
        }

        const n = findById(id);

        if (n) {
            n.destroy();
        }
    });
}
