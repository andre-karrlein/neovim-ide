"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const apiutils_1 = require("./apiutils");
const clusterprovider = require("./clusterprovider/versions");
const kubectl = require("./kubectl/versions");
const commandTargets = require("./command-targets/versions");
const explorerTree = require("./explorer-tree/versions");
function apiBroker(clusterProviderRegistry, kubectlImpl, explorer) {
    return {
        get(component, version) {
            switch (component) {
                case "clusterprovider": return clusterprovider.apiVersion(clusterProviderRegistry, version);
                case "kubectl": return kubectl.apiVersion(kubectlImpl, version);
                case "commandtargets": return commandTargets.apiVersion(version);
                case "explorertree": return explorerTree.apiVersion(explorer, version);
                default: return apiutils_1.versionUnknown;
            }
        },
        // Backward compatibility
        apiVersion: '1.0',
        clusterProviderRegistry: clusterProviderRegistry
    };
}
exports.apiBroker = apiBroker;
//# sourceMappingURL=apibroker.js.map