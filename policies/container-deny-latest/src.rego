# METADATA
# title: Images must not use the latest tag
# description: |-
#   Using the latest tag on images can cause unexpected problems in production. By specifying a pinned version
#   we can have higher confidence that our applications are immutable and do not change unexpectedly.
# custom:
#   matchers:
#     kinds:
#     - apiGroups:
#       - ""
#       kinds:
#       - Pod
#     - apiGroups:
#       - apps
#       kinds:
#       - DaemonSet
#       - Deployment
#       - StatefulSet

package containerDenyLatest

import data.lib.core
import data.lib.pods

policyID := "P1001"

violation[msg] {
	pods.containers[container]
	has_latest_tag(container)

	msg := core.format_with_id(sprintf("%s/%s/%s: Images must not use the latest tag", [core.kind, core.name, container.name]), policyID)
}

has_latest_tag(c) {
	endswith(c.image, ":latest")
}

has_latest_tag(c) {
	contains(c.image, ":") == false
}
