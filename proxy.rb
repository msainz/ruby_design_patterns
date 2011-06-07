
# Proxy Pattern: akin to Adapter, but wraps the object with an intent of control.
# The proxy isn't there to 'translate' an interface, and most often it has the same
# interface as the object being wrapped. Proxies are good for tasks such as hiding the
# fact that an object really lives across the network, enforcing security, abd delaying 
# the creation of the real object until the last possible moment.