"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function impl(kubectl) {
    return new KubectlV1Impl(kubectl);
}
exports.impl = impl;
class KubectlV1Impl {
    constructor(kubectl) {
        this.kubectl = kubectl;
    }
    invokeCommand(command) {
        return this.kubectl.invokeAsync(command);
    }
}
//# sourceMappingURL=v1.js.map