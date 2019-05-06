'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
var si = require('systeminformation');
function activate(context) {
    var resourceMonitor = new ResMon();
    resourceMonitor.StartUpdating();
    context.subscriptions.push(resourceMonitor);
}
exports.activate = activate;
var Units;
(function (Units) {
    Units[Units["NoSuffix"] = 1] = "NoSuffix";
    Units[Units["Kilo"] = 1024] = "Kilo";
    Units[Units["Mega"] = 1048576] = "Mega";
    Units[Units["Giga"] = 1073741824] = "Giga";
})(Units || (Units = {}));
var FreqMappings = {
    "GHz": Units.Giga,
    "MHz": Units.Mega,
    "KHz": Units.Kilo,
    "Hz": Units.NoSuffix
};
var MemMappings = {
    "GB": Units.Giga,
    "MB": Units.Mega,
    "KB": Units.Kilo,
    "B": Units.NoSuffix
};
class Resource {
    constructor(config, isShownByDefault, configKey) {
        this._config = config;
        this._isShownByDefault = isShownByDefault;
        this._configKey = configKey;
    }
    getResourceDisplay() {
        return __awaiter(this, void 0, void 0, function* () {
            return this.isShown() ? this.getDisplay() : null;
        });
    }
    isShown() {
        return this._config.get(this._configKey, this._isShownByDefault);
    }
}
class CpuUsage extends Resource {
    constructor(config) {
        super(config, true, "showcpuusage");
    }
    getDisplay() {
        return __awaiter(this, void 0, void 0, function* () {
            let currentLoad = yield si.currentLoad();
            return `$(pulse) ${(100 - currentLoad.currentload_idle).toFixed(2)}%`;
        });
    }
}
class CpuFreq extends Resource {
    constructor(config) {
        super(config, true, "showcpufreq");
    }
    getDisplay() {
        return __awaiter(this, void 0, void 0, function* () {
            let cpuData = yield si.cpu();
            // systeminformation returns frequency in terms of GHz by default
            let speedHz = parseFloat(cpuData.speed) * Units.Giga;
            let formattedWithUnits = this.getFormattedWithUnits(speedHz);
            return `$(dashboard) ${(formattedWithUnits)}`;
        });
    }
    getFormattedWithUnits(speedHz) {
        var unit = this._config.get('frequnit', "GHz");
        var freqDivisor = FreqMappings[unit];
        return `${(speedHz / freqDivisor).toFixed(2)} ${unit}`;
    }
}
class Battery extends Resource {
    constructor(config) {
        super(config, false, "showbattery");
    }
    getDisplay() {
        return __awaiter(this, void 0, void 0, function* () {
            let rawBattery = yield si.battery();
            return `$(zap) ${rawBattery.percent}%`;
        });
    }
}
class Memory extends Resource {
    constructor(config) {
        super(config, true, "showmem");
    }
    getDisplay() {
        return __awaiter(this, void 0, void 0, function* () {
            var memDivisor = MemMappings[this._config.get('memunit', "GB")];
            let memoryData = yield si.mem();
            let memoryUsedWithUnits = memoryData.active / memDivisor;
            let memoryTotalWithUnits = memoryData.total / memDivisor;
            return `$(ellipsis) ${(memoryUsedWithUnits).toFixed(2)}/${(memoryTotalWithUnits).toFixed(2)} GB`;
        });
    }
}
class ResMon {
    constructor() {
        this._statusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left);
        this._statusBarItem.show();
        this._config = vscode_1.workspace.getConfiguration('resmon');
        this._delimiter = "    ";
        this._updating = false;
    }
    StartUpdating() {
        this._updating = true;
        this.update(this._statusBarItem);
    }
    StopUpdating() {
        this._updating = false;
    }
    update(statusBarItem) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this._updating) {
                // Add all resources to monitor
                let resources = [];
                resources.push(new CpuUsage(this._config));
                resources.push(new CpuFreq(this._config));
                resources.push(new Battery(this._config));
                resources.push(new Memory(this._config));
                // Get the display of the requested resources
                let pendingUpdates = resources.map(resource => resource.getResourceDisplay());
                // Wait for the resources to update
                yield Promise.all(pendingUpdates).then(finishedUpdates => {
                    // Remove nulls, join with delimiter
                    statusBarItem.text = finishedUpdates.filter(update => update !== null).join(this._delimiter);
                });
                setTimeout(() => this.update(statusBarItem), this._config.get('updatefrequencyms', 2000));
            }
        });
    }
    dispose() {
        this.StopUpdating();
        this._statusBarItem.dispose();
    }
}
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map