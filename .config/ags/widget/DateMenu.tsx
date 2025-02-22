import { App, Gtk, Astal } from "astal/gtk3";
import { Calendar } from "./Calendar";

export function DateMenu() {
    return (
        <window
            visible={false}
            name="datemenu"
            namespace="datemenu"
            className="popup-window"
            application={App}
            layer={Astal.Layer.OVERLAY}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        >
            <box
                className="bg-body rounded-xl"
                valign={Gtk.Align.START}
                vertical
                vexpand={false}
                widthRequest={400}
            >
                <Calendar
                    className="calendar"
                    detailHeightRows={100}
                    detailWidthChars={100}
                    noMonthChange
                />
            </box>
        </window>
    );
}
