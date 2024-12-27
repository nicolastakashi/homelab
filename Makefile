
install-cilium:
	@helm upgrade -i cilium cilium/cilium --namespace cilium --set operator.replicas=1 --set MTU=1500 --set k8sServiceHost=${API_SERVER_IP} --set k8sServicePort=${API_SERVER_PORT} --set kubeProxyReplacement=true --create-namespace

.PHONY: setup
setup: install-cilium