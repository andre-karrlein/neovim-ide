"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const webpanel_1 = require("../webpanel/webpanel");
class DescribePanel extends webpanel_1.WebPanel {
    constructor(panel, content, resource) {
        super(panel, content, resource, DescribePanel.currentPanels);
    }
    static createOrShow(content, resource) {
        const fn = (panel, content, resource) => {
            return new DescribePanel(panel, content, resource);
        };
        webpanel_1.WebPanel.createOrShowInternal(content, resource, DescribePanel.viewType, "Kubernetes Describe", DescribePanel.currentPanels, fn);
    }
    update() {
        this.panel.title = `Kubernetes describe ${this.resource}`;
        this.panel.webview.html = `
    <!doctype html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Kubernetes describe ${this.resource}</title>
    </head>
    <body>
        <code>
            <pre>${this.content}</pre>
        </code>
    </body>
    </html>`;
    }
}
DescribePanel.viewType = 'vscodeKubernetesDescribe';
DescribePanel.currentPanels = new Map();
exports.DescribePanel = DescribePanel;
//# sourceMappingURL=describeWebview.js.map