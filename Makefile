CILIUM_VALUES_FILE=apps/cilium/values.yaml
DEFAULT_API_SERVER_PORT=6443

install-cilium:
	@helm upgrade -i cilium cilium/cilium --namespace cilium --set operator.replicas=1 --set MTU=1500 --set k8sServiceHost=${API_SERVER_IP} --set k8sServicePort=${API_SERVER_PORT} --set kubeProxyReplacement=true --create-namespace

update-cilium-values:
	@if [ -z "$(API_SERVER_IP)" ]; then \
		echo "Error: API_SERVER_IP environment variable is not set."; \
		exit 1; \
	fi
	@API_SERVER_PORT="${API_SERVER_PORT:-$(DEFAULT_API_SERVER_PORT)}"; \
	if [ -z "$$API_SERVER_PORT" ]; then \
		API_SERVER_PORT=$(DEFAULT_API_SERVER_PORT); \
	fi; \
	echo "Using API_SERVER_PORT=$$API_SERVER_PORT"; \
	API_SERVER_PORT=$$API_SERVER_PORT yq eval '.cilium.k8sServiceHost = env(API_SERVER_IP) | .cilium.k8sServicePort = strenv(API_SERVER_PORT)' -i $(CILIUM_VALUES_FILE)
	@echo "Updated cilium.k8sServiceHost with $$API_SERVER_IP and cilium.k8sServicePort with $$API_SERVER_PORT in $(CILIUM_VALUES_FILE)."

	@if [ -z "$(LB_IP_RANGE_START)" ]; then \
		echo "Error: LB_IP_RANGE_START environment variable is not set."; \
		exit 1; \
	fi
	@if [ -z "$(LB_IP_RANGE_END)" ]; then \
		echo "Error: LB_IP_RANGE_END environment variable is not set."; \
		exit 1; \
	fi
	@echo "Using LB_IP_RANGE_START=$(LB_IP_RANGE_START) and LB_IP_RANGE_END=$(LB_IP_RANGE_END)"; \
	LB_IP_RANGE_START=$(LB_IP_RANGE_START) LB_IP_RANGE_END=$(LB_IP_RANGE_END) \
	yq eval '.lbIPPool.start = env(LB_IP_RANGE_START) | .lbIPPool.stop = env(LB_IP_RANGE_END)' -i $(CILIUM_VALUES_FILE)
	@echo "Updated lbIPPool.start with $(LB_IP_RANGE_START) and lbIPPool.stop with $(LB_IP_RANGE_END) in $(CILIUM_VALUES_FILE)."

	@echo "Updating ingressController.service.annotations.io.cilium/lb-ipam-ips with $(LB_IP_RANGE_START) in $(CILIUM_VALUES_FILE)"
	yq eval '.cilium.ingressController.service.annotations."io.cilium/lb-ipam-ips" = env(LB_IP_RANGE_START)' -i $(CILIUM_VALUES_FILE)
	@echo "Updated ingressController.service.annotations.io.cilium/lb-ipam-ips successfully."

.PHONY: setup
setup: install-cilium update-cilium-values