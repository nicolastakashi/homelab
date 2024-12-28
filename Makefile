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

.PHONY: setup
setup: install-cilium update-cilium-values