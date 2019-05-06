'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
var si = require('systeminformation');
function activate(context) {
    context.subscriptions.push(new ResMon());
}
exports.activate = activate;
var Units;
(function (Units) {
    Units[Units["Kilo"] = 1024] = "Kilo";
    Units[Units["Mega"] = 1048576] = "Mega";
    Units[Units["Giga"] = 1073741824] = "Giga";
})(Units || (Units = {}));
var FreqMappings = {
    "GHz": Units.Giga,
    "MHz": Units.Mega,
    "KHz": Units.Kilo,
    "Hz": 1
};
var MemMappings = {
    "GB": Units.Giga,
    "MB": Units.Mega,
    "KB": Units.Kilo,
    "B": 1
};
class ResMon {
    constructor() {
        this._statusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left);
        this.update(this._statusBarItem);
        this._statusBarItem.show();
    }
    update(statusBarItem) {
        let config = vscode_1.workspace.getConfiguration('resmon');
        let stats = [];
        if (config.get('showcpuusage', true)) {
            let usage = si.currentLoad().then((data) => { return `$(pulse) ${(100 - data.currentload_idle).toFixed(2)}%`; });
            stats.push(usage);
        }
        if (config.get('showcpufreq', true)) {
            var freqDivisor = FreqMappings[config.get('frequnit', "GHz")];
            let freq = si.cpu().then(
            // systeminformation returns frequency in terms of GHz by default
            (data) => { return `$(dashboard) ${(parseFloat(data.speed) / (freqDivisor / Units.Giga)).toFixed(2)} GHz`; });
            stats.push(freq);
        }
        if (config.get('showmem', true)) {
            var memDivisor = MemMappings[config.get('memunit', "GB")];
            let mem = si.mem().then((data) => { return `$(ellipsis) ${(data.used / memDivisor).toFixed(2)}/${(data.total / memDivisor).toFixed(2)} GB`; });
            stats.push(mem);
        }
        if (config.get('showbattery', true)) {
            let battery = si.battery().then((data) => { return `$(zap) ${data.percent}%`; });
            stats.push(battery);
        }
        Promise.all(stats).then((data) => {
            statusBarItem.text = data.join('   ');
            setTimeout(() => this.update(statusBarItem), config.get('updatefrequencyms', 2000));
        }).catch();
    }
    dispose() {
        this._statusBarItem.dispose();
    }
}
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension-DESKTOP-5HOVDA3.js.map