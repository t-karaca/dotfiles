import { Gtk, astalify, ConstructProps } from "astal/gtk3";
import { GObject } from "astal";

export class ProgressBar extends astalify(Gtk.ProgressBar) {
    static {
        GObject.registerClass(this);
    }

    constructor(
        props: ConstructProps<ProgressBar, Gtk.ProgressBar.ConstructorProps>,
    ) {
        super(props as any);
    }
}
