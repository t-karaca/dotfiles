import { Variable } from "astal";

function formatBytes(bytes: number) {
    const giga = bytes / 1024 / 1024;
    return `${giga.toFixed(2)} GiB`;
}

export const gpuStats$ = Variable({
    usage: "",
    temperature: "",
    usedMemory: "",
    totalMemory: "",
}).poll(
    2000,
    [
        "nvidia-smi",
        "--query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total",
        "--format=csv,noheader,nounits",
    ],
    out => {
        const [usage, temp, memUsed, memTotal] = out.split(", ");

        return {
            usage: `${usage}%`,
            temperature: `${temp}°C`,
            usedMemory: `${(parseInt(memUsed) / 1024).toFixed(2)}GiB`,
            totalMemory: `${(parseInt(memTotal) / 1024).toFixed(2)}GiB`,
        };
    },
);

export const ramStats$ = Variable({
    used: "",
    total: "",
}).poll(2000, ["free", "--kibi"], out => {
    const [total, used] = out
        .split("\n")
        .find(line => line.includes("Mem:"))!
        .split(/\s+/)
        .splice(1, 2);

    return {
        used: formatBytes(parseInt(used)),
        total: formatBytes(parseInt(total)),
    };
});

export const cpuTemp$ = Variable(0).poll(
    2000,
    ["cat", "/sys/class/thermal/thermal_zone0/temp"],
    out => parseInt(out) / 1000,
);

export const cpuUsage$ = Variable("").poll(
    2000,
    ["top", "-b", "-n", "1"],
    out =>
        parseFloat(
            out
                .split("\n")
                .find(line => line.includes("Cpu(s)"))!
                .split(/\s+/)[1]
                .replace(",", "."),
        ).toFixed(2) + "%",
);
