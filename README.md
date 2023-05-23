You can access the deployed Helloworld app on this url

https://test-aks-ingress-hello-world.eastus.cloudapp.azure.com/

- Please note that since the certificate issuer is staging server of the lets encrypt it would show as invalid cert but one can bypass that to see the app
- App showcases the configuration of the ingress controller to capture the IP from where the traffic is originating through X-Forwarded-For header. so basically dumping the headers to test it
- Private enpdoint for SQL Server to enable communication from the aks vnet

# TODO:

Need to add functionality to store the ip of the client to sqlserver. 