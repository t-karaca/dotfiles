import { App } from "astal/gtk3";
import style from "./style.scss";
import { Launcher } from "./widget/Launcher";
import { OSD } from "./widget/OSD";
import { Notifications } from "./widget/Notifications";
import { PowerMenu } from "./widget/PowerMenu";

App.start({
    css: style,
    main() {
        OSD();
        Launcher();
        Notifications();
        PowerMenu();
    },
});
